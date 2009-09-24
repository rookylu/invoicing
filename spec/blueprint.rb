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

VatRate.blueprint do
  name { Sham.title }
end

Company.blueprint do
  email_address { Sham.email }
  name { Sham.company_name }
  vat_number
  url
  phone_number
end

Client.blueprint do
  name { Sham.company_name }
  abbreviated { name.slice(0,2) }
  email_address { Sham.email }
  vat_number
  billing_person { Sham.name }
end

Product.blueprint do
  name { Sham.product_name }
end

Invoice.blueprint do
  client { Client.first || Client.make }
  ident { |x| "#{client.abbreviated}#{DateTime.now}-%02d" % x }
end
