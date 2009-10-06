class CreateInvoiceLines < ActiveRecord::Migration
  def self.up
    create_table :invoice_lines do |t|
      t.integer :invoice_id
      t.integer :product_id
      t.integer :price
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_lines
  end
end
