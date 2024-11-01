class AddCityAndStateField < ActiveRecord::Migration
  def self.up
    add_column :territories, :state, :string
    add_column :territories, :city, :string
  end

  def self.down
    remove_column :territories, :city
    remove_column :territories, :state
  end
end
