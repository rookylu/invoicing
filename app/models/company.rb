# == Schema Information
#
# Table name: companies
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  phone_number  :string(255)
#  email_address :string(255)
#  url           :string(255)
#  address       :text
#  vat_number    :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Company < ActiveRecord::Base
  has_attached_file :logo, :styles => { :thumb => ["100x100>", :jpg], :normal => ["200x200>", :jpg] }, :default_style => :thumb

  validates_attachment_content_type :logo, :content_type => ['image/tiff', 'image/svg.*', 'image/gif', 'image/jpg', 'image/jpeg', 'image/png'], :message => "Logo is not of an acceptable type"

end
