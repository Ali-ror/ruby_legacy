class RemoveUserType < ActiveRecord::Migration
  def self.up
    remove_column :users, :user_type
    add_column :users, :global_admin, :boolean, :default => false
  end

  def self.down
    remove_column :users, :global_admin
    add_column :users, :user_type, :string, :default => "consumer"
  end
end