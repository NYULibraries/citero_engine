Rails.application.routes.draw do

  mount Citation::Engine, :at => '/cite'
end
