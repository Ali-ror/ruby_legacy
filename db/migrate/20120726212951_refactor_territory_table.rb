class RefactorTerritoryTable < ActiveRecord::Migration
  def self.up
    create_table :territory_texts do |t|
      t.references :territory
      t.string     :contents_type, :limit => 50
      t.text       :contents,      :limit => 4294967295

      t.timestamps
    end
  end

  def self.down
    drop_table :territory_texts
  end
end
