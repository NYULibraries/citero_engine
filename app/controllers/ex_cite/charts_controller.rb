module ExCite
  class ChartsController < ActionController::Base
    def index
      render :layout => false, :template => 'ex_cite/cite/charts'
    end
  end
end
