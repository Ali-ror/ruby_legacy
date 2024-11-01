class FixModels < ActiveRecord::Migration
  def self.up
    create_table :user_coupons do |t|
      t.references :user
      t.references :coupon

      t.timestamp
    end

    add_column :coupons, :business_listing_id, :integer
    add_column :coupons, :user_coupon_id, :integer
    add_column :business_listings, :territory_id, :integer

  end

  def self.down
    drop_table :user_coupons
    remove_column :coupons, :business_listing_id
    remove_column :coupons, :user_coupon_id
    remove_column :business_listing, :territory_id
  end
end
