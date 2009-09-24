require 'spec_helper'

describe Invoice do
  before(:each) do
    @valid_attributes = {
      :ident => "value for ident",
      :date => Time.now,
      :date_sent => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Invoice.create!(@valid_attributes)
  end
end
