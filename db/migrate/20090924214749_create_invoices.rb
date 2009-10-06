class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :ident
      t.datetime :date_sent
      t.datetime :date_approved
      t.datetime :date_paid
      t.datetime :date
      t.integer :client_id, :null => false

      t.timestamps
    end

    execute "ALTER TABLE invoices ADD state ENUM('proforma', 'invoice', 'sent', 'paid') NOT NULL;"
  end

  def self.down
    remove_column :invoices, :state
    drop_table :invoices
  end
end
