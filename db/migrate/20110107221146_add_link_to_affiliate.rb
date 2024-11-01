class AddLinkToAffiliate < ActiveRecord::Migration
  def self.up
    add_column :affiliates, :link, :string
  end

  def self.down
    remove_column :affiliates, :link
  end
end
