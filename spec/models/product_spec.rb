# == Schema Information
#
# Table name: products
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  price      :integer(4)
#  details    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Product do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :price => 1,
      :details => "value for details"
    }
  end

  it "should create a new instance given valid attributes" do
    Product.create!(@valid_attributes)
  end
end
