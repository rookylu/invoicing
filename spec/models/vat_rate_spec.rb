# == Schema Information
#
# Table name: vat_rates
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  vat_rate       :integer(4)
#  effective_from :datetime
#  effective_to   :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

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
