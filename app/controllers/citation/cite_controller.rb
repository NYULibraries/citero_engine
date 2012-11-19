require_dependency "citation/application_controller"
require "citation/engine"

require 'open-uri'
module Citation
  class CiteController < ApplicationController
    def redir
      puts "{request.env['PATH_INFO']}"
      if( params[:format].nil? )
        raise ArgumentError, 'Missing Output Format'
      end
      if( request.env['PATH_INFO'].eql? "/cite" )
        openurl
      else
        recordID
      end
    end
    
    def index
      render :text => "Citation Mounted"
    end
    
    def recordID
      if( params[:format].eql?("refworks") || params[:format].eql?("endnote") )
        export
      else
        record = Record.find_by_title(params[:id])
        send_data( Citation.map(record[:raw]).from(record[:formatting]).to(params[:format]) , :filename => "export."+params[:format], :type => "text/plain")
      end
    end
    
    def openurl
      if( params[:format].eql?("refworks") || params[:format].eql?("endnote") )
        export
      else
        send_data( Citation.map(request.fullpath).from("openurl").to(params[:format]) , :filename => "export."+params[:format], :type => "text/plain")
      end
    end
    
    def export
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
      send_data( Citation.map(params[:data]).from(params[:from]).to(params[:to]) , :type => "text/plain")
    end
  end
end
