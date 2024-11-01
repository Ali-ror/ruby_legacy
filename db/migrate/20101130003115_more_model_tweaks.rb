class MoreModelTweaks < ActiveRecord::Migration
  def self.up
    rename_column :link_types, :type, :name
    add_column :categories, :territory_id, :integer
    change_column :headers, :credit, :string
  end

  def self.down
    rename_column :link_types, :name, :type
    remove_column :categories, :territory_id
    change_column :headers, :credit, :boolean
  end
end
