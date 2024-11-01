class AddInitalIndexes < ActiveRecord::Migration
  def self.up
    add_index :categories, [ :territory_id, :name ]
    add_index :business_listings, [ :territory_id, :state, :expires ]
    add_index :addresses, [ :model_id, :model_type ]
  end

  def self.down
    remove_index :categories, [:territory_id, :name ]
    remove_index :business_listings, [ :id, :state, :expires ]
    remove_index :addresses, [ :model_id, :model_type ]
  end
end
