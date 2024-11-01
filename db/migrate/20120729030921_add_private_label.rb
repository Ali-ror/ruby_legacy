class AddPrivateLabel < ActiveRecord::Migration
  def self.up
    add_column :territories, :brand_name, :string
    add_column :territories, :brand_default_logo, :string
    add_column :territories, :territory_type, :string
  end

  def self.down
    remove_column :territories, :brand_name
    remove_column :territories, :brand_default_logo
    remove_column :territories, :territory_type
  end
end
