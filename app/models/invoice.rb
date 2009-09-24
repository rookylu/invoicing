class Invoice < ActiveRecord::Base

  acts_as_state_machine :initial => :created, :column => 'status'

  state :sent

  event :send_to_cleint do
    transition :from => :created, :to => :sent
  end

end
