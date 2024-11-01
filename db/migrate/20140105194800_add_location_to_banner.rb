class AddLocationToBanner < ActiveRecord::Migration
  def self.up
    add_column :banners, :location_mask, :integer
  end

  def self.down
    remove_column :banners, :location_mask
  end
end
