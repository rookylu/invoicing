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

set_scene("one company and one client") do
  Company.make
  Client.make(:name => 'Example Client')
end

set_scene("50 Companies") do
  50.times do
    Company.make
  end
end

set_scene("100 Products") do 
  100.times do
    Product.make
  end
end

set_scene("20 Clients") do
  20.times do
    Client.make
  end
end

set_scene("100 Proformas") do
  100.times do
    Invoice.make(:state => 'proforma')
  end
end

set_scene("200 Invoices") do
  200.times do
    Invoice.make(:state => 'invoice')
  end
end

set_scene("400 InvoiceLines") do
  400.times do
    InvoiceLine.make
  end
end

set_scene("20 clients each with 30 invoices") do
  get_scene("100 Products").play
  get_scene("20 Clients").play
  Client.all.each do |client|
    30.times do
      invoice = Invoice.make(:client => client)
      5.times do
        prod = Product.find(rand(100)+1)
        InvoiceLine.make(:product => prod, :invoice => invoice)
      end
    end
  end
end

set_scene("A lot of data") do
  get_scene("VAT rates").play
  get_scene("50 Companies").play
  get_scene("20 clients each with 30 invoices").play
end
