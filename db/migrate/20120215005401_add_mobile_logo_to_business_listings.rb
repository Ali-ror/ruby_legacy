class AddMobileLogoToBusinessListings < ActiveRecord::Migration
  def self.up
    add_column :business_listings, :mobile_logo, :string
  end

  def self.down
    remove_column :business_listings, :mobile_logo
  end
end
