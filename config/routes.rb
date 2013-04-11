ExCite::Engine.routes.draw do
  get "cite/:to_format(/:id)" => "cite#index", as: :to_format
  match "cite" => 'cite#index', :via => [:get,:post]
end
