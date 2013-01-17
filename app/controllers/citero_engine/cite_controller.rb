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
      out_format = whitelist_method('to',params[:format])
      if( params[:id] )
        record = Record.find_by_title(params[:id])
        in_format = whitelist_method('from',record[:formatting])
        data = Citero.map(record[:raw]).send(in_format).send(out_format)  unless record.nil?
      else
        data = Citero.map(CGI::unescape(request.protocol+request.host_with_port+request.fullpath)).from_openurl.send(out_format)
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
      in_format = whitelist_method('from',params[:from])
      out_format = whitelist_method('from',params[:to])
      send_data( Citero.map(params[:data]).send(in_format).send(out_format) , :type => "text/plain")
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
    
    def whitelist_method direction, format
      if( direction.eql? "to" )
        if Citero.map("").to_formats.include? format
          return "to_#{format}"
        end
      elsif( direction.eql? "from" )
        if Citero.map("").from_formats.include? format
          return "from_#{format}"
        end
      end
    end
  end
end
