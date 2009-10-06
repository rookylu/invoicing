require 'spec_helper'

describe InvoiceLine do
  before(:each) do
    @valid_attributes = {
      :invoice_id => 1,
      :product_id => 1,
      :price => 1,
      :quantity => 1
    }
  end

  it "should create a new instance given valid attributes" do
    InvoiceLine.create!(@valid_attributes)
  end
end
