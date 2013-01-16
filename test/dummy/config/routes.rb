Rails.application.routes.draw do

  mount CiteroEngine::Engine, :at => '/cite'
end
