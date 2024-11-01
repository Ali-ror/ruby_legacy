class AddMeetOwner < ActiveRecord::Migration
  def self.up
    add_column :business_listings, :owner_photo, :string
    add_column :business_listings, :owner_name, :string
    add_column :business_listings, :owner_bio, :text
  end

  def self.down
    remove_column :business_listings, :owner_photo
    remove_column :business_listings, :owner_name
    remove_column :business_listings, :owner_bio
  end
end
