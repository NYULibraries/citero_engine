require_dependency "citero_engine/application_controller"
require "citero_engine/engine"
require "citero"
require 'digest/sha1'
  
require 'open-uri'
module CiteroEngine
  class CiteController < ApplicationController
    before_filter :valid_to_format?
    
    def valid_to_format?
      head :bad_request unless to_format      
    end
    
    def to_format
      @to_format ||= whitelist_formats :to, params[:to_format]
    end
    private :to_format
    
    class Citation
      attr_reader :data, :from_format, :resource_key
      def initialize *args
        @data = args[0]
        @from_format = args[1]
        (args[2].nil?) ? construct_key : @resource_key = args[2]
      end
      
      def construct_key
        @resource_key = Digest::SHA1.hexdigest(@data)+'_'+@from_format.formatize
      end
    end
    
    def citations
     unless defined? @citations
      @citations = []
      @citations += record_citation + resource_citation + format_citation
      if @citations.empty?
        @citations << open_url_citation
      end
     else
      return @citations
     end
    end
    
    def record_citation
      (params[:id].nil?) ? [] :
        params[:id].collect do |id|
          record = Record.find_by_id id
          if record.nil?
            return []
          end
          Citation.new record[:raw], (whitelist_formats :from, record[:formatting])
        end
    end
    
    def resource_citation
      (params[:resource_key].nil?) ? [] :
        params[:resource_key].collect do |key|
          Citation.new nil, nil, key
      end
    end
    
    def format_citation
      (params[:from_format].nil? || params[:data].nil?) ? [] :
        params[:from_format].collect.with_index do |format, index|
          Citation.new params[:data].to_a[index], (whitelist_formats :from, format)
        end
    end
    
    def open_url_citation
      Citation.new CGI::unescape(request.protocol+request.host_with_port+request.fullpath), (whitelist_formats :from, 'openurl')
    end
    
    def fetch_or_map_and_cache
      @output = ""
      citations.collect do |cite|
        @output += (Rails.cache.fetch(cite.resource_key) { Citero.map(cite.data).send(cite.from_format).send(@to_format) } ) + "\n"
      end
    rescue TypeError => exc
      raise ArgumentError, "Data or source format not provided. [data => #{@data}, from_format => #{@from_format}]"
    end
    
    def flow
      citations
      fetch_or_map_and_cache
      handle
    rescue ArgumentError => exc
      handle_invalid_arguments
    end
    

    
    def handle
      if push_to_is_set? then push else download end
    end

    # Cleans the user input and finds the associated method for that format
    def whitelist_formats direction, format
      if direction.nil? || format.nil?
        return
      end
      if (direction == :to && Citero.to_formats.include?(format.downcase))||(direction == :from && Citero.from_formats.include?(format.downcase))
        return "#{direction.to_s}_#{format.downcase}"
      end
      # p format.to_sym
      if push_formats.include? format.to_sym
        @push_to = push_formats[format.to_sym]
        @to_format = @push_to[:format].downcase
        return "#{direction.to_s}_#{@to_format}"
      end
    end
    
    def handle_invalid_arguments
      head :bad_request
    end
    
    def push_to_is_set?
      not @push_to.nil?
    end

    def push
      if @push_to[:action].eql? :redirect
        @data = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
        redirect_to @push_to[:url]+callback, :status => 303
      elsif @push_to[:action].eql? :method
        send @push_to[:method]
      end
    end

    def download
      send_data @output.force_encoding('UTF-8'), :filename => filename, :type => 'application/ris'
    end

    
    def push_formats
      @push_formats ||= Hash[:easybibpush => Hash[ :format => :easybib, :action => :method, :method => :push_to_easybib], 
                             :endnote => Hash[ :format => :ris, :action => :redirect, :url => 'http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl='], 
                             :refworks => Hash[ :format => :ris, :action => :redirect, :url => 'http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url='] ]
    end
    
    def callback
      callback = "#{request.protocol}#{request.host_with_port}#{request.fullpath.split('?')[0]}?"
      citations.collect do |cite|
        callback += "resource_key[]=#{cite.resource_key}&"
      end
      callback += "to_format=#{@to_format.formatize}"
      ERB::Util.url_encode(callback)
    end
    
    # Creates the filename and extension. Few are application specific
    def filename
      name = "export"
      case @to_format
      when "to_bibtex"
        name += ".bib"
      when "to_easybib"
        name += ".json"
      else
        name += "." + @to_format.formatize
      end
      name
    end
    
    # Defines a form for the push to easybib
    def push_to_easybib
      @elements = [{:name => "data", :value => "[" + @output + "]", :type => "textarea"}]
      @name = "Push to EasyBib"
      @action = "http://www.easybib.com/cite/bulk"
      @method = "POST"
      @enctype = "application/x-www-form-urlencoded"
      render :template => "citero_engine/cite/external_form"
    end
  end
end
