class CreateVatRates < ActiveRecord::Migration
  def self.up
    create_table :vat_rates do |t|
      t.string :name
      t.integer :vat_rate
      t.datetime :effective_from
      t.datetime :effective_to

      t.timestamps
    end
  end

  def self.down
    drop_table :vat_rates
  end
end
