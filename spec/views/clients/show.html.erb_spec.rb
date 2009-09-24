require 'spec_helper'

describe "/clients/show.html.erb" do
  include ClientsHelper
  before(:each) do
    assigns[:client] = @client = stub_model(Client,
      :name => "value for name",
      :abbreveated => "value for abbreveated",
      :billing_person => "value for billing_person",
      :phone_number => "value for phone_number",
      :address => "value for address",
      :country => "value for country",
      :vat_number => "value for vat_number",
      :email_addres => "value for email_addres"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ abbreveated/)
    response.should have_text(/value\ for\ billing_person/)
    response.should have_text(/value\ for\ phone_number/)
    response.should have_text(/value\ for\ address/)
    response.should have_text(/value\ for\ country/)
    response.should have_text(/value\ for\ vat_number/)
    response.should have_text(/value\ for\ email_addres/)
  end
end
