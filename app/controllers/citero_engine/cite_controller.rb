require_dependency "citero_engine/application_controller"
require "citero_engine/engine"
require "citero"
require 'digest/sha1'

require 'open-uri'
module CiteroEngine
  class CiteController < ApplicationController
    # Mount point for the engine
    def index
      render :text => "CiteroEngine Mounted"
    end
    
    def flow
      gather
      map
      handle
    rescue ArgumentError => exc
      handle_invalid_arguments
    end
    
    def gather
      if params[:id] then get_from_record else get_from_params end
      if @data.nil? and params[:resource_key].nil? then assume_openurl end
      @to_format ||= whitelist_formats :to, params[:to_format] unless params[:to_format].nil?
      if @data.nil? or @from_format.nil? or @to_format.nil?
        raise ArgumentError, "Some parameters may be missing [data => #{@data}, from_format => #{@from_format}, to_format => #{@to_format}]"
      end
    end
    
    def handle_invalid_arguments
      head :bad_request
    end
    
    def get_from_record
      record = Record.find_by_id params[:id]
      @data = record[:raw] unless record.nil?
      @from_format = whitelist_formats :from, record[:formatting] unless record.nil?
    end
    
    def get_from_params
      @data ||= params[:data] if params[:data] else @data ||= get_from_cache
      @from_format ||= whitelist_formats :from, params[:from_format] unless params[:from_format].nil?
    end
    
    def assume_openurl
      @data ||= CGI::unescape(request.protocol+request.host_with_port+request.fullpath)
      @from_format ||= 'from_openurl'
    end
    
    def map
      @output = Citero.map(@data).send(@from_format).send(@to_format)
    end
    
    def handle
      if push_to_is_set? then push else download end
    end
    
    def download
      send_data @output.force_encoding('UTF-8'), :filename => filename, :type => 'application/ris'
    end
    
    def push
      if @push_to[:action].eql? :redirect
        cache_resource
        redirect_to @push_to[:url]+callback, :status => 303
      elsif @push_to[:action].eql? :method
        send @push_to[:method]
      end
    end
    
    def callback
      ERB::Util.url_encode("#{request.protocol}#{request.host_with_port}#{request.fullpath.split('?')[0]}?resource_key=#{@resource_key}&to_format=#{@push_to[:format]}&from_format=#{@from_format.split('_').last}" )
    end
    
    def cache_resource
      @resource_key = Digest::SHA1.hexdigest(@data)
      Rails.cache.write(@resource_key, @data)
    end
    
    def get_from_cache 
      Rails.cache.fetch(params[:resource_key]) if params[:resource_key]
    end
    
    # Creates a new record with data, format, and title, redirects to that resource
    def create
      r = Record.create(:raw => params[:data], :formatting => params[:from_format], :title => params[:ttl])
      if r.save
        redirect_to "/cite", "id"=>params[:ttl], "format"=>params[:from_format], :status => 303
      else
        handle_invalid_arguments
      end
    end
    
    # Direct access to translation process, used by existing resources
    def translate
      flow if params[:data] else handle_invalid_arguments and return
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
    
    # Creates the filename and extension. Few are application specific
    def filename
      name = "export"
      case @to_format
      when "to_bibtex"
        name += ".bib"
      when "to_easybib"
        name += ".json"
      else
        name += "." + @to_format.split('_').last
      end
      name
    end
    
    def push_formats
      @push_formats ||= Hash[:easybibpush => Hash[ :format => :easybib, :action => :method, :method => :push_to_easybib], 
                             :endnote => Hash[ :format => :ris, :action => :redirect, :url => 'http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl='], 
                             :refworks => Hash[ :format => :ris, :action => :redirect, :url => 'http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url='] ]
    end
    
    def push_to_is_set?
      not @push_to.nil?
    end
    
    # Cleans the user input and finds the associated method for that format
    def whitelist_formats direction, format
      if [:to, :from].include? direction
        if Citero.to_formats.include? format.downcase or Citero.from_formats.include? format.downcase
          return "#{direction.to_s}_#{format.downcase}"
        end
      end
      if push_formats.include? format.to_sym
        @push_to = push_formats[format.to_sym]
        return "#{direction.to_s}_#{@push_to[:format].downcase}"
      end
    end
  end
end
