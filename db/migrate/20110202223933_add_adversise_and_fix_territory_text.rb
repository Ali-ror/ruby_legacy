class AddAdversiseAndFixTerritoryText < ActiveRecord::Migration
  def self.up
    add_column :territories, :advertise_with_us, :text
    change_column :territories, :connect_text, :text
    change_column :territories, :discovery_text, :text
    change_column :territories, :save_text, :text
  end

  def self.down
    remove_column :territories, :advertise_with_us
    change_column :territories, :connect_text, :string
    change_column :territories, :discovery_text, :string
    change_column :territories, :save_text, :string
  end
end
