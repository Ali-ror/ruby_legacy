class RemoveTextsFromTerritoryTable < ActiveRecord::Migration
  def self.up
    remove_column :territories, :can_rely_text
    remove_column :territories, :discovery_text
    remove_column :territories, :save_text
    remove_column :territories, :connect_text
    remove_column :territories, :what_is_relylocal
    remove_column :territories, :advertise_with_us
    remove_column :territories, :list_your_businesses
    remove_column :territories, :show_your_support
    remove_column :territories, :contact_us
    remove_column :territories, :rewards_text

    remove_column :territories, :local_businesses
    remove_column :territories, :local_coupons
    remove_column :territories, :local_jobs
  end

  def self.down
  end
end
