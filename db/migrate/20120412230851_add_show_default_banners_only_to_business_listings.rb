class AddShowDefaultBannersOnlyToBusinessListings < ActiveRecord::Migration
  def self.up
    add_column :business_listings, :show_default_banners_only, :boolean
  end

  def self.down
    remove_column :business_listings, :show_default_banners_only
  end
end
