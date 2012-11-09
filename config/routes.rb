Citation::Engine.routes.draw do
  root :to => 'cite#index'
  match "records/:id/:format" => 'cite#index'
  match ":data/:from/:to" => 'cite#translate'
  post "records" => 'cite#create'
end
