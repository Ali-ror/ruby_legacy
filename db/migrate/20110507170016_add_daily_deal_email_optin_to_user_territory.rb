class AddDailyDealEmailOptinToUserTerritory < ActiveRecord::Migration
  def self.up
    add_column :user_territories, :subscribe_daily_deal_email, :boolean
  end

  def self.down
    remove_column :user_territories, :subscribe_daily_deal_email
  end
end
