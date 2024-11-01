class AddRewardsAndDeals < ActiveRecord::Migration
  def self.up
    create_table :rewards do |t|
      t.string :description
      t.date :expiration_date
      t.boolean :never_expires
      
      t.references :business_listing

      t.timestamps
    end

    create_table :daily_deals do |t|
      t.string :title
      t.string :description
      t.string :restrictions
      t.date :expiration_date
      t.string :deal_image

      t.references :business_listing

      t.timestamps
    end

    create_table :user_daily_deals do |t|
      t.references :user
      t.references :daily_deal
    end

    add_column :territories, :rewards_text, :text
    add_column :territories, :rewards_enabled, :boolean
    add_column :territories, :deal_of_the_day_enabled, :boolean
  end

  def self.down
    drop_table :rewards
    drop_table :daily_deals
    drop_table :user_daily_deals
    remove_column :territories, :rewards_text
    remove_column :territories, :rewards_enabled
    remove_column :territories, :deal_of_the_day_enabled
  end
end
