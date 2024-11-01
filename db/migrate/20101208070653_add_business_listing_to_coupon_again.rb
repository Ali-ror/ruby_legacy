class AddBusinessListingToCouponAgain < ActiveRecord::Migration
  def self.up
    add_column :coupons, :business_listing_id, :integer
  end

  def self.down
    remove_column :coupons, :business_listing_id
  end
end
