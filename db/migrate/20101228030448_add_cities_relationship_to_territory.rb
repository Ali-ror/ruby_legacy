class AddCitiesRelationshipToTerritory < ActiveRecord::Migration
  def self.up
    remove_column :territories, :city
    remove_column :territories, :state
    remove_column :territories, :primary_zip_code

    create_table :cities do |t|
      t.string :city
      t.string :state

      t.references :territory

      t.timestamps
    end
  end

  def self.down
    add_column :territories, :city, :string
    add_column :territories, :state, :string
    add_column :territories, :primary_zip_code, :string

    drop_table :cities
  end
end
