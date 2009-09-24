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

class Invoice < ActiveRecord::Base

  belongs_to :client

  acts_as_state_machine :initial => :created, :column => 'status'

  state :sent

  event :send_to_cleint do
    transitions :from => :created, :to => :sent
  end

end
