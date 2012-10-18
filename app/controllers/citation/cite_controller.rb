require_dependency "citation/application_controller"
require "citation/engine"

module Citation
  class CiteController < ApplicationController
    def index
      data =  Citation.map(params[:map]).from(params[:from]).to(params[:to])
      send_data( data , :filename => "export."+params[:to])
    end
  end
end
