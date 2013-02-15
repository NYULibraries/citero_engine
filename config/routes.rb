CiteroEngine::Engine.routes.draw do
  match "cite" => 'cite#flow'
  post "batch" => 'cite#batch'
end
