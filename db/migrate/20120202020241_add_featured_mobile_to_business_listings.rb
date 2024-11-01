class AddFeaturedMobileToBusinessListings < ActiveRecord::Migration
  def self.up
    add_column :business_listings, :featured_mobile, :boolean
    add_column :business_listings, :featured_mobile_date, :date
  end

  def self.down
    remove_column :business_listings, :featured_mobile_date
    remove_column :business_listings, :featured_mobile
  end
end
