require_dependency "citero_engine/application_controller"
require "citero_engine/engine"
require "citero"

require 'open-uri'
module CiteroEngine
  class CiteController < ApplicationController
    def redir
      if( params[:format].nil? )
        raise ArgumentError, 'Missing Output Format'
      end
      if( params[:format].eql?("refworks") || params[:format].eql?("endnote") || params[:format].eql?("pusheasybib") )
        export
      else
        cite
      end
    end
    
    def index
      render :text => "CiteroEngine Mounted"
    end
    
    def cite
      data = get_data
      data.nil? ? raise( ArgumentError, "Unrecognized request" ) : send_data( data, :filename => filename , :type => "text/plain")
    end
    
    def get_data
      if( params[:id] )
        record = Record.find_by_title(params[:id])
        if( record.nil? )
           raise( ArgumentError, "Unknown record" )
           return
        end
        data = Citero.map(record[:raw])
        from = record[:formatting]
        to = params[:format]
        if( data.from_formats.include? from )
          data = data.send("from_#{from}")
        else
            raise( ArgumentError, "Unrecognized request" )
        end
        if( data.to_formats.include? to )
          data = data.send("to_#{to}")
        else
            raise( ArgumentError, "Unrecognized request" )
        end
      else
        data = Citero.map(CGI::unescape(request.protocol+request.host_with_port+request.fullpath)).from_openurl.to(params[:format]) 
      end
    end
    
    def export
      if( params[:format].eql?("pusheasybib"))
        push_to_easybib
        return
      end
      callback = params[:format].eql?("refworks") ? "http://www.refworks.com/express/ExpressImport.asp?vendor=Primo&filter=RIS%20Format&encoding=65001&url="
                                                  : "http://www.myendnoteweb.com/?func=directExport&partnerName=Primo&dataIdentifier=1&dataRequestUrl=" 
      callback += ERB::Util.url_encode("#{request.protocol}#{request.host_with_port}#{request.fullpath.sub(/refworks/, 'ris' ).sub(/endnote/, 'ris')}" )
      redirect_to callback, :status => 303
    end
    
    def create
      r = Record.create(:raw => params[:data], :formatting => params[:from], :title => params[:ttl])
      if r.valid?
        r.save
        redirect_to "/cite", "id"=>params[:ttl], "format"=>params[:from], :status => 303
      else
        raise ArgumentError, 'Missing Parameters'
      end
    end
    
    def translate
      if( params[:data].nil? or params[:from].nil? or params[:to].nil? )
        raise ArgumentError, 'Missing Parameters'
      end
      send_data( Citero.map(params[:data]).send("from_#{params[:from]}").send("to_#{params[:to]}") , :type => "text/plain")
    end
    
    def filename
      name = "export"
      if( params[:format].eql?("bibtex") )
        name += ".bib"
      elsif( params[:format].eql?("easybib") )
        name += ".json"
      else
        name += "." + params[:format]
      end
      return name
    end
    
    def push_to_easybib
      params[:format] = "easybib"
      @elements = [{:name => "data", :value => "[" + get_data + "]", :type => "textarea"}]
      @name = "Push to EasyBib"
      @action = "http://www.easybib.com/cite/bulk"
      @method = "POST"
      @enctype = "application/x-www-form-urlencoded"
      render :template => "citero_engine/cite/external_form"
    end
  end
end
