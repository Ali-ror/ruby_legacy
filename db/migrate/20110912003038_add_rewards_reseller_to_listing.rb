class AddRewardsResellerToListing < ActiveRecord::Migration
  def self.up
    add_column :business_listings, :reward_reseller, :boolean
  end

  def self.down
    remove_column :business_listings, :reward_reseller
  end
end
