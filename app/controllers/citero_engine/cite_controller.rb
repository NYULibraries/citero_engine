require_dependency "citero_engine/application_controller"
require "citero_engine/engine"
require "citero"

require 'open-uri'
module CiteroEngine
  class CiteController < ApplicationController
    # Mount point for the engine
    def index
      render :text => "CiteroEngine Mounted"
    end
    
    def gather   
      if !params[:id].nil? 
        record = Record.find_by_id params[:id]
        @data = record[:raw] unless record.nil?
        @from_format = whitelist_formats :from, record[:formatting] unless record.nil?
      else
        @data = params[:data] unless params[:data].nil?
        @from_format = whitelist_formats :from, params[:from_format] unless params[:from_format].nil?
      end
      
      @data = CGI::unescape(request.protocol+request.host_with_port+request.fullpath) unless !params[:data].nil?
      @from_format = 'from_openurl' unless !params[:from_format].nil?
      @to_format = whitelist_formats :to, params[:to_format] unless params[:to_format].nil?
      
      if @data.nil? or @from_format.nil? or @to_format.nil?
        raise ArgumentError, "Some parameters may be missing [data => #{@data}, from_format => #{@from_format}, to_format => #{@to_format}]"
      end
      
      p "Parameters set [data => #{@data}, from_format => #{@from_format}, to_format => #{@to_format}]"
      
    end
    
    
    
    # Creates a new record with data, format, and title, redirects to that resource
    def create
      r = Record.create(:raw => params[:data], :formatting => params[:from_format], :title => params[:ttl])
      if r.valid?
        r.save
        redirect_to "/cite", "id"=>params[:ttl], "format"=>params[:from_format], :status => 303
      else
        raise ArgumentError, 'Missing Parameters'
      end
    end

    # Direct access to translation process, used by existing resources
    def translate
      if( params[:data].nil? or params[:from_format].nil? or params[:to_format].nil? )
        raise ArgumentError, 'Missing Parameters'
      end
      in_format = whitelist_formats :from, params[:from_format]
      out_format = whitelist_formats :from, params[:to_format]
      send_data( Citero.map(params[:data]).send(in_format).send(out_format) ,:filename => filename, :type => "text/plain")
    end
        
    # Redirection based on format, figures out which method to call based on the output format
    def redir
      gather
      if( params[:to_format].nil? )
        raise ArgumentError, 'Missing Output Format'
      end
      if( params[:to_format].eql?("refworks") || params[:to_format].eql?("endnote") || params[:to_format].eql?("easybibpush") )
        push
      else
        cite
      end
    end
    
    # This method sends the data to the user.
    def cite
      data = get_data
      data.nil? ? raise( ArgumentError, "Unrecognized request" ) : send_data( data, :filename => filename , :type => "text/plain")
    end
    
    # The method that actually converts input data to a desired output format, does both openurl and records
    def get_data
      out_format = whitelist_formats :to,params[:to_format]
      if( params[:id] )
        record = Record.find_by_id(params[:id])
        in_format = whitelist_formats :from, record[:formatting]
        data = Citero.map(record[:raw]).send(in_format).send(out_format)  unless record.nil?
      else
        raw_data = CGI::unescape(request.protocol+request.host_with_port+request.fullpath)
        data = Citero.map(raw_data).from_openurl.send(out_format)
      end
    end
    
    # Export method that pushes to easybib, refworks, or endnote
    def push
      case params[:to_format]
      when "easybibpush"
        params[:to_format] = "easybib"
        push_to_easybib
        return
      when "refworks"
        callback = "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url="
      when "endnote"
        callback = "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl="
      end
      
      callback += ERB::Util.url_encode("#{request.protocol}#{request.host_with_port}#{request.fullpath.sub(/refworks/, 'ris' ).sub(/endnote/, 'ris')}" )
      redirect_to callback, :status => 303
    end
    
    # Defines a form for the push to easybib
    def push_to_easybib
      @elements = [{:name => "data", :value => "[" + get_data + "]", :type => "textarea"}]
      @name = "Push to EasyBib"
      @action = "http://www.easybib.com/cite/bulk"
      @method = "POST"
      @enctype = "application/x-www-form-urlencoded"
      render :template => "citero_engine/cite/external_form"
    end
    
    # Creates the filename and extension. Few are application specific
    def filename
      name = "export"
      
      case params[:to_format]
      when "bibtex"
        name += ".bib"
      when "easybib"
        name += ".json"
      else
        name += "." + params[:to_format]
      end
      
      return name
    end
    
    def push_formats
      @push_formats ||= Hash['easybibpush' => Hash[ 'format' => 'easybib', 'action' => 'method', 'method' => 'push_to_easybib'], 
                             'endnote' => Hash[ 'format' => 'ris', 'action' => 'redirect', 'url' => ''], 
                             'refworks' => Hash[ 'format' => 'ris', 'action' => 'redirect', 'url' => ''], ]
    end
    # Cleans the user input and finds the associated method for that format
    def whitelist_formats direction, format
      if direction.to_s.eql? "to" or direction.to_s.eql? "from"
        if Citero.to_formats.include? format.downcase or Citero.from_formats.include? format.downcase
          return "#{direction.to_s}_#{format.downcase}"
        end
      end
      if push_formats.include? format
        return "#{direction.to_s}_#{push_formats[format]['format'].downcase}"
      end
    end
  end
end
