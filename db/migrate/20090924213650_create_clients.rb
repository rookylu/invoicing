class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name
      t.string :abbreveated
      t.string :billing_person
      t.string :phone_number
      t.text :address
      t.string :country
      t.string :vat_number
      t.string :email_addres

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
