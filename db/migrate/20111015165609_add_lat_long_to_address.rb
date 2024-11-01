class AddLatLongToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :latitude, :float
    add_column :addresses, :longitude, :float
  end

  def self.down
    remove_column :addresses, :longitude
    remove_column :addresses, :latitude
  end
end
