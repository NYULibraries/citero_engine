require_dependency "citation/application_controller"
require "citation/engine"

module Citation
  class CiteController < ApplicationController
    def index
      send_data( Citation.map(params[:map]).from(params[:from]).to(params[:to]) , :filename => "export."+params[:to], :type => "text/plain")
    end
  end
end
