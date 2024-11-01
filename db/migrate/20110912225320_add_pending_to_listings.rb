class AddPendingToListings < ActiveRecord::Migration
  def self.up
    add_column :business_listings, :published, :boolean
  end

  def self.down
    remove_column :business_listings, :published
  end
end
