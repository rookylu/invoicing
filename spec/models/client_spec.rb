require 'spec_helper'

describe Client do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :abbreveated => "value for abbreveated",
      :billing_person => "value for billing_person",
      :phone_number => "value for phone_number",
      :address => "value for address",
      :country => "value for country",
      :vat_number => "value for vat_number",
      :email_addres => "value for email_addres"
    }
  end

  it "should create a new instance given valid attributes" do
    Client.create!(@valid_attributes)
  end
end
