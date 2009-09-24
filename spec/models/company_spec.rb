require 'spec_helper'

describe Company do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :phone_number => "value for phone_number",
      :email_address => "value for email_address",
      :url => "value for url",
      :address => "value for address",
      :vat_number => "value for vat_number"
    }
  end

  it "should create a new instance given valid attributes" do
    Company.create!(@valid_attributes)
  end
end
