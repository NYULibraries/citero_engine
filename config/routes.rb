CiteroEngine::Engine.routes.draw do
  root :to => 'cite#index'
  match "cite/:id" => 'cite#redir'
  match "cite" => 'cite#redir'
  match "translate/:data/:from_format/:to_format" => 'cite#translate'
  post "records" => 'cite#create'
end
