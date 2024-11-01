class FixTerritoryFieldsAgain < ActiveRecord::Migration
  def self.up
    change_column :territories, :what_is_relylocal, :text
    change_column :territories, :list_your_businesses, :text
    change_column :territories, :show_your_support, :text
    change_column :territories, :contact_us, :text
    change_column :territories, :local_businesses, :text
    change_column :territories, :local_coupons, :text
    change_column :territories, :local_jobs, :text
    change_column :territories, :discovery_text, :string
    change_column :territories, :save_text, :string
    change_column :territories, :connect_text, :string
    change_column :territories, :can_rely_text, :string
  end

  def self.down
  end
end
