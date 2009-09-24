ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../config/environment"

require 'machinist'
require 'spec/blueprint'
require 'spec/mocks'

set_scene("VAT rates") do
  VatRate.make(:vat_rate => 1150, :effective_from => DateTime.parse('2008-12-01'), :effective_to => DateTime.parse('2010-01-01'))
  VatRate.make(:vat_rate => 1175, :effective_to => DateTime.parse('2008-12-01'))
  VatRate.make(:vat_rate => 1175, :effective_from => DateTime.parse('2010-01-01'))
end

set_scene("Lots of Companies") do
  10.times do
    Company.make
  end
end

set_scene("Lots of Products") do 
  100.times do
    Product.make
  end
end

set_scene("Lots of Clients") do
  20.times do
    Client.make
  end
end

set_scene("A lot of data") do
  get_scene("VAT rates").play
  get_scene("Lots of Companies").play
  get_scene("Lots of Products").play
  get_scene("Lots of Clients").play
end
