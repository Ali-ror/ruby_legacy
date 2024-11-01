class AddFeaturedOwnersToBusinessListings < ActiveRecord::Migration
  def self.up
    add_column :business_listings, :featured_owner, :boolean
    add_column :business_listings, :featured_owner_date, :date
  end

  def self.down
    remove_column :business_listings, :featured_owner_date
    remove_column :business_listings, :featured_owner
  end
end
