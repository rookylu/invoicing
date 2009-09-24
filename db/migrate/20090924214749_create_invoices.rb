class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :ident
      t.datetime :date
      t.datetime :date_sent

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
