class CreateClientGroups < ActiveRecord::Migration
  def self.up
    create_table :client_groups do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :client_groups
  end
end
