Citation::Engine.routes.draw do
  root :to => 'cite#index'
  match "records/:id/:format" => 'cite#index'
  match "records" => 'cite#create', :via => :post
end
