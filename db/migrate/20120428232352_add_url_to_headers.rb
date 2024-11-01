class AddUrlToHeaders < ActiveRecord::Migration
  def self.up
    add_column :headers, :link, :string
  end

  def self.down
    remove_column :headers, :link
  end
end
