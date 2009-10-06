# == Schema Information
#
# Table name: client_groups
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ClientGroup < ActiveRecord::Base
end
