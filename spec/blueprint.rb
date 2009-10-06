require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.name  { Faker::Name.name }
Sham.email { Faker::Internet.email }
Sham.title { Faker::Lorem.sentence }
Sham.body  { Faker::Lorem.paragraph }
Sham.phone_number { Faker::PhoneNumber.phone_number }
Sham.url { Faker::Internet.domain_name }
Sham.address { Faker::Address.street_address }
Sham.vat_number { |x| "UK%08d" % x }
Sham.company_name { Faker::Company.name }
Sham.product_name { Faker::Lorem.sentence }
Sham.price(:unique => false) { rand(50000) + 1 }
Sham.logo { File.new(Dir.glob("/Library/User Pictures/*/*.tif").rand) }

VatRate.blueprint do
  name { Sham.title }
end

Company.blueprint do
  email_address { Sham.email }
  name { Sham.company_name }
  vat_number
  url
  phone_number
  logo
end

Client.blueprint do
  name { Sham.company_name }
  abbreviated { name.slice(0,2).upcase }
  email_address { Sham.email }
  country 'United Kingdom'
  vat_number
  phone_number
  billing_person { Sham.name }
end

Product.blueprint do
  name { Sham.product_name }
  price 
  details { Sham.body }
end

Invoice.blueprint do
  client { Client.make }
  ident { "#{client.abbreviated}#{Date.today.to_s(:yearonly).gsub(/-/,'')}-%02d" % (rand(99) + 1) }
  state 'proforma'
  date { Date.today - rand(100) }
end

InvoiceLine.blueprint do
  invoice { Invoice.make }
  product { Product.make }
  price
  quantity { rand(10) + 1 }
end
