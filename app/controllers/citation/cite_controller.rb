require_dependency "citation/application_controller"

module Citation
  class CiteController < ApplicationController
    def index
      data = "hersheys"
      send_data( data, :filename => "export.ris")
    end
    def to(format)
    end
  end
end
