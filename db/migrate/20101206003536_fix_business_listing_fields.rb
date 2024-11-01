class FixBusinessListingFields < ActiveRecord::Migration
  def self.up
    rename_column :business_listings, :long_desription, :long_description
    change_column :business_listings, :package_type, :string
    remove_column :business_listings, :owner
    add_column :business_listings, :visits, :integer
  end

  def self.down
    rename_column :business_listings, :long_description, :long_desription
    change_column :business_listings, :package_type, :integer
    add_column :business_listings, :owner, :string
    remove_column :business_listings, :visits
  end
end
