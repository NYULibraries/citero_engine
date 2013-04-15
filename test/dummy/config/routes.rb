Rails.application.routes.draw do

  mount ExCite::Engine, :at => '/cite'
end
