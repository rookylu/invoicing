class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :product

  delegate :name, :to => :product

  def total
    self.price * self.quantity
  end
end
