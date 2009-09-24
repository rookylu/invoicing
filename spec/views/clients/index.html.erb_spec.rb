require 'spec_helper'

describe "/clients/index.html.erb" do
  include ClientsHelper

  before(:each) do
    assigns[:clients] = [
      stub_model(Client,
        :name => "value for name",
        :abbreveated => "value for abbreveated",
        :billing_person => "value for billing_person",
        :phone_number => "value for phone_number",
        :address => "value for address",
        :country => "value for country",
        :vat_number => "value for vat_number",
        :email_addres => "value for email_addres"
      ),
      stub_model(Client,
        :name => "value for name",
        :abbreveated => "value for abbreveated",
        :billing_person => "value for billing_person",
        :phone_number => "value for phone_number",
        :address => "value for address",
        :country => "value for country",
        :vat_number => "value for vat_number",
        :email_addres => "value for email_addres"
      )
    ]
  end

  it "renders a list of clients" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for abbreveated".to_s, 2)
    response.should have_tag("tr>td", "value for billing_person".to_s, 2)
    response.should have_tag("tr>td", "value for phone_number".to_s, 2)
    response.should have_tag("tr>td", "value for address".to_s, 2)
    response.should have_tag("tr>td", "value for country".to_s, 2)
    response.should have_tag("tr>td", "value for vat_number".to_s, 2)
    response.should have_tag("tr>td", "value for email_addres".to_s, 2)
  end
end
