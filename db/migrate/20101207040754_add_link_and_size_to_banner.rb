class AddLinkAndSizeToBanner < ActiveRecord::Migration
  def self.up
    add_column :banners, :link, :string
    add_column :banners, :size, :string
  end

  def self.down
    remove_column :banners, :link
    remove_column :banners, :size
  end
end
