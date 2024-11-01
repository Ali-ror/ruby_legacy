class ChangeCouponDescriptionToRestriction < ActiveRecord::Migration
  def self.up
    rename_column :coupons, :description, :restrictions
  end

  def self.down
    rename_column :coupons, :restrictions, :description
  end
end