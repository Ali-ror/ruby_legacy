class AddBusinessListingBusinessTierAndTerritoryTracking < ActiveRecord::Migration
  def self.up
    add_column :business_listings, :business_tier, :string
    add_column :territories, :tracking_code, :text
  end

  def self.down
    remove_column :business_listings, :business_tier
    remove_column :territories, :tracking_code
  end
end
