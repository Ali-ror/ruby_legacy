class AddCategoryPathCache < ActiveRecord::Migration
  def self.up
    add_column :categories, :path_name_cache, :string
  end

  def self.down
    remove_column :categories, :path_name_cache
  end
end
