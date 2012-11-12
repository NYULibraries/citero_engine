require_dependency "citation/application_controller"
require "citation/engine"

module Citation
  class CiteController < ApplicationController
    def index
      if( params[:id].nil? or params[:format].nil? )
        raise ArgumentError, 'Missing Parameters'
      end
      record = Record.find_by_title(params[:id])
      send_data( Citation.map(record[:raw]).from(record[:formatting]).to(params[:format]) , :filename => "export."+params[:format], :type => "text/plain")
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
