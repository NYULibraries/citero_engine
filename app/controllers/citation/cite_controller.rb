require_dependency "citation/application_controller"
require "citation/engine"

module Citation
  class CiteController < ApplicationController
    def index
      @record = Record.find_by_title(params[:id])
      send_data( Citation.map(@record[:raw]).from(@record[:formatting]).to(params[:format]) , :filename => "export."+params[:format], :type => "text/plain")
    end
    
    def create
      r = Record.create(:raw => params[:data], :formatting => params[:from], :title => params[:ttl])
      r.save
      redirect_to "index", "id"=>params[:ttl], "format"=>params[:from], :status => 303
    end
  end
end
