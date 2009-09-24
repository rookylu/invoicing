class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :ident
      t.datetime :date
      t.datetime :date_sent

      t.timestamps
    end

    execute "ALTER TABLE invoices ADD state ENUM('created', 'sent') NOT NULL;"
  end

  def self.down
    remove_column :invoices, :state
    drop_table :invoices
  end
end
