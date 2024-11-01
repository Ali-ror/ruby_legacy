class AddActiveInMobileAppsToCoupons < ActiveRecord::Migration
  def self.up
    add_column :coupons, :active_in_mobile_apps, :boolean, :default => true
  end

  def self.down
    remove_column :coupons, :active_in_mobile_apps
  end
end
