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

class Product < ActiveRecord::Base
end
