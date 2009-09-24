# == Schema Information
#
# Table name: clients
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  abbreviated    :string(255)
#  billing_person :string(255)
#  phone_number   :string(255)
#  address        :text
#  country        :string(255)
#  vat_number     :string(255)
#  email_address  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Client < ActiveRecord::Base
end
