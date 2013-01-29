CiteroEngine::Engine.routes.draw do
  root :to => 'cite#index'
  # match "cite/:id" => 'cite#redir'
  # match "cite" => 'cite#redir'
  match "translate/:data/:from_format/:format" => 'cite#translate'
  match "cite" => 'cite#gather'
  post "records" => 'cite#create'
end
