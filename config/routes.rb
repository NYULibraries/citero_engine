Citation::Engine.routes.draw do
  root :to => 'cite#index'
  match "records/:id/:format" => 'cite#index'
  post "records" => 'cite#create'
end
