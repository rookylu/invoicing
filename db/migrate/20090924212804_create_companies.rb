class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :phone_number
      t.string :email_address
      t.string :url
      t.text :address
      t.string :vat_number

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
