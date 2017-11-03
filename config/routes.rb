CiteroEngine::Engine.routes.draw do
  match "citero_engine(/:to_format)(/:id)" => 'citero_engine#index', :via => [:get, :post], :as => "citero_engine"
end
