class AddDealDateToDealOfTheDay < ActiveRecord::Migration
  def self.up
    add_column :daily_deals, :deal_date, :date
  end

  def self.down
    remove_column :daily_deals, :deal_date
  end
end
