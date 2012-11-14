Citation::Engine.routes.draw do
  root :to => 'cite#index'
  match "records/:id/:format" => 'cite#index'
  match "translate/:data/:from/:to" => 'cite#translate'
  match "translate" => 'cite#translate'
  post "records" => 'cite#create'
end
