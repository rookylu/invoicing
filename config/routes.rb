ActionController::Routing::Routes.draw do |map|
  map.resources :invoices, :member => { :approve_proforma => :get,:send_to_client => :get, :receive_payment => :get } do |invoice|
    invoice.resources :invoice_lines
  end
  map.resources :clients do |client|
    client.resources :invoices
  end
  map.resources :vat_rates
  map.resources :client_groups
  map.resources :companies
  map.resources :products
  map.root :controller => "invoices"
end
