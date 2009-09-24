ActionController::Routing::Routes.draw do |map|
  map.resources :invoices
  map.resources :clients
  map.resources :vat_rates
  map.resources :client_groups
  map.resources :companies
  map.resources :products
  map.root :controller => "invoices"
end
