class ChangeAdminTypeToUserType < ActiveRecord::Migration
  def self.up
    rename_column :users, :admin_type, :user_type
  end

  def self.down
    rename_column :users, :user_type, :admin_type
  end
end