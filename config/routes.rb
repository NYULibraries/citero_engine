ExCite::Engine.routes.draw do
  match "export_citations(/:to_format)(/:id)" => 'export_citations#index', :via => [:get, :post], :as => "export_citations"
  match "charts" => "charts#index", :via => [:get]
end
