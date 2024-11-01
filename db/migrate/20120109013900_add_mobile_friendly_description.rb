class AddMobileFriendlyDescription < ActiveRecord::Migration
  def self.up
    add_column :business_listings, :mobile_friendly_description, :text
  end

  def self.down
    remove_column :business_listings, :mobile_friendly_description, :text
  end
end
