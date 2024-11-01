class AddMoreTerritoryFields < ActiveRecord::Migration
  def self.up
    add_column :territories, :featured_link, :string
    add_column :territories, :local_businesses, :string
    add_column :territories, :local_coupons, :string
    add_column :territories, :local_jobs, :string
    add_column :territories, :what_is_relylocal, :string
    add_column :territories, :list_your_businesses, :string
    add_column :territories, :show_your_support, :string
    add_column :territories, :contact_us, :string
    add_column :territories, :page_title, :string
    add_column :territories, :meta_description, :string
    add_column :territories, :meta_tags, :string
  end

  def self.down
  end
end
