class AddHideEvents < ActiveRecord::Migration
  def self.up
    add_column :territories, :hide_events_calendar, :boolean
  end

  def self.down
    remove_column :territories, :hide_events_calendar
  end
end
