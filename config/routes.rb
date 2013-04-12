ExCite::Engine.routes.draw do
  match "export_citations(/:to_format)" => 'export_citations#index', :via => [:get, :post], :as => "export_citations"
end
