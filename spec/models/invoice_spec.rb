# == Schema Information
#
# Table name: invoices
#
#  id         :integer(4)      not null, primary key
#  ident      :string(255)
#  date       :datetime
#  date_sent  :datetime
#  client_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  state      :string(0)       not null
#

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
