class AddCouponDescriptionColumn < ActiveRecord::Migration
  def self.up
    rename_column :coupons, :restrictions, :description
    add_column :coupons, :restrictions, :string
  end

  def self.down
    remove_column :coupons, :restrictions
    rename_column :coupons, :description, :restrictions
  end
end
