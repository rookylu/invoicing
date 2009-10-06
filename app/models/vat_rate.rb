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

class VatRate < ActiveRecord::Base
end
