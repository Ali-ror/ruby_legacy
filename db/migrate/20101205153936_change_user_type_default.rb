class ChangeUserTypeDefault < ActiveRecord::Migration
  def self.up
    change_column_default :users, :user_type, "consumer"
  end

  def self.down
    change_column_default :users, :user_type, "territory"
  end
end