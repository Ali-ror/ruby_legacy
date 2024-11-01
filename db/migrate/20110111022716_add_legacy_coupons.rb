class AddLegacyCoupons < ActiveRecord::Migration
  def self.up
    create_table :legacy_coupons do |t|
      t.string :legacy_coupon
      t.references :business_listing
    end
  end

  def self.down
    drop_table :legacy_coupons
  end
end
