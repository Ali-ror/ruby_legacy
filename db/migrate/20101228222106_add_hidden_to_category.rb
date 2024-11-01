class AddHiddenToCategory < ActiveRecord::Migration
  def self.up
    create_table :hidden_categories do |t|
      t.references :territory
      t.references :category

      t.timestamps
    end
  end

  def self.down
    drop_table :hidden_categories
  end
end
