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
  has_many :invoice_lines
  has_many :products, :through => :invoice_lines

  named_scope :proformas, :conditions => { :state => "proforma" }
  named_scope :invoices, :conditions => [ "state != 'proforma'" ]

  acts_as_state_machine :initial => :invoice, :column => 'state'

  state :proforma
  state :invoice, :enter => :invoice_approved
  state :sent, :enter => :send_invoice_to_client
  state :paid, :enter => :invoice_paid

  event :approved do
    transitions :from => :proforma, :to => :invoice
  end

  event :send_to_client do
    transitions :from => :invoice, :to => :sent
  end

  event :receive_payment do
    transitions :from => :sent, :to => :paid
  end

  def state_info(date_format = :standard)
    info = self.state.capitalize
    status_date = case state
                  when 'invoice'
                    date_approved
                  when 'sent'
                    date_sent
                  when 'paid'
                    date_paid
                  end
    info << " at #{status_date.to_s(date_format)}" unless status_date.blank?
    info
  end

  def send_invoice_to_client
    self.date_sent = DateTime.now
  end

  def invoice_approved
    self.date_approved = DateTime.now
  end

  def invoice_paid
    self.date_paid = DateTime.now
  end

  def total
    invoice_lines.map{|x| x.total}.reduce(:+)
  end

  def num_lines
    invoice_lines.map{|x| x.quantity}.reduce(:+)
  end

end
