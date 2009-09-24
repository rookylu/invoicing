require 'spec_helper'

describe VATRate do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :vat_rate => 1,
      :effective_from => Time.now,
      :effective_to => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    VATRate.create!(@valid_attributes)
  end
end
