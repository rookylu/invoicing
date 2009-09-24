require 'spec_helper'

describe "/clients/edit.html.erb" do
  include ClientsHelper

  before(:each) do
    assigns[:client] = @client = stub_model(Client,
      :new_record? => false,
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

  it "renders the edit client form" do
    render

    response.should have_tag("form[action=#{client_path(@client)}][method=post]") do
      with_tag('input#client_name[name=?]', "client[name]")
      with_tag('input#client_abbreveated[name=?]', "client[abbreveated]")
      with_tag('input#client_billing_person[name=?]', "client[billing_person]")
      with_tag('input#client_phone_number[name=?]', "client[phone_number]")
      with_tag('textarea#client_address[name=?]', "client[address]")
      with_tag('input#client_country[name=?]', "client[country]")
      with_tag('input#client_vat_number[name=?]', "client[vat_number]")
      with_tag('input#client_email_addres[name=?]', "client[email_addres]")
    end
  end
end
