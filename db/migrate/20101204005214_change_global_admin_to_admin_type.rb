class ChangeGlobalAdminToAdminType < ActiveRecord::Migration
  def self.up
    remove_column :users, :global_admin
    add_column :users, :admin_type, :string, :default => "territory"
  end

  def self.down
    remove_column :users, :admin_type
    add_column :users, :global_admin, :boolean,                        :default => false
  end
end