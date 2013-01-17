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
    
    # Creates a new record with data, format, and title, redirects to that resource
    def create
      r = Record.create(:raw => params[:data], :formatting => params[:from], :title => params[:ttl])
      if r.valid?
        r.save
        redirect_to "/cite", "id"=>params[:ttl], "format"=>params[:from], :status => 303
      else
        raise ArgumentError, 'Missing Parameters'
      end
    end

    # Direct access to translation process, used by existing resources
    def translate
      if( params[:data].nil? or params[:from].nil? or params[:to].nil? )
        raise ArgumentError, 'Missing Parameters'
      end
      in_format = whitelist_method('from',params[:from])
      out_format = whitelist_method('from',params[:to])
      send_data( Citero.map(params[:data]).send(in_format).send(out_format) , :type => "text/plain")
    end
        
    # Redirection based on format, figures out which method to call based on the output format
    def redir
      if( params[:format].nil? )
        raise ArgumentError, 'Missing Output Format'
      end
      if( params[:format].eql?("refworks") || params[:format].eql?("endnote") || params[:format].eql?("easybib") )
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
      out_format = whitelist_method('to',params[:format])
      if( params[:id] )
        record = Record.find_by_title(params[:id])
        in_format = whitelist_method('from',record[:formatting])
        data = Citero.map(record[:raw]).send(in_format).send(out_format)  unless record.nil?
      else
        data = Citero.map(CGI::unescape(request.protocol+request.host_with_port+request.fullpath)).from_openurl.send(out_format)
      end
    end
    
    # Export method that pushes to easybib, refworks, or endnote
    def push
      case params[:format]
      when "easybib"
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
      
      case params[:format]
      when "bibtex"
        name += ".bib"
      when "easybib"
        name += ".json"
      else
        name += "." + params[:format]
      end
      
      return name
    end
    
    # Cleans the user input and finds the associated method for that format
    def whitelist_method direction, format
      if( direction.eql? "to" )
        if Citero.map("").to_formats.include? format.downcase
          return "to_#{format.downcase}"
        end
      elsif( direction.eql? "from" )
        if Citero.map("").from_formats.include? format.downcase
          return "from_#{format.downcase}"
        end
      end
    end
  end
end
