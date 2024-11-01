class FixTerritoryFieldsAgainAgain < ActiveRecord::Migration
  def self.up
    change_column :territories, :can_rely_text, :text
  end

  def self.down
  end
end
