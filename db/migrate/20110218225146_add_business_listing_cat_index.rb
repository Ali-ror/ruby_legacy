class AddBusinessListingCatIndex < ActiveRecord::Migration
  def self.up
    add_index :business_listing_categories, [ :category_id, :business_listing_id ], :name => "bl_cats_index"
  end

  def self.down
    remove_index :business_listing_categories, :name => "bl_cats_index"
  end
end
