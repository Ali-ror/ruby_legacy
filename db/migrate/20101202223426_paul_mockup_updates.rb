class PaulMockupUpdates < ActiveRecord::Migration
  def self.up
    add_column :territories, :discovery_text, :text
    add_column :territories, :save_text, :text
    add_column :territories, :connect_text, :text
    add_column :territories, :can_rely_text, :text

    add_column :business_listings, :package_type, :integer
    add_column :business_listings, :short_description, :string
    add_column :business_listings, :long_desription, :text
    add_column :business_listings, :hide_address, :boolean
    add_column :business_listings, :hide_map, :boolean
    add_column :business_listings, :email, :string
    add_column :business_listings, :user_id, :integer
  end

  def self.down
    remove_column :territories, :discovery_text
    remove_column :territories, :save_text
    remove_column :territories, :connect_text
    remove_column :territories, :can_rely_text

    remove_column :business_listings, :package_type
    remove_column :business_listings, :short_description
    remove_column :business_listings, :long_desription
    remove_column :business_listings, :hide_address
    remove_column :business_listings, :hide_map
    remove_column :business_listings, :email
    remove_column :business_listings, :user_id
  end
end
