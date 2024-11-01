class AddLoginAndGlobalAdminToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :login, :string
    add_column :users, :global_admin, :boolean
  end

  def self.down
    remove_column :users, :global_admin
    remove_column :users, :login
  end
end