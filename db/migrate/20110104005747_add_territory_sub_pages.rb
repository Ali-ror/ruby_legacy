class AddTerritorySubPages < ActiveRecord::Migration
  def self.up
    create_table :sub_pages do |t|
      t.references :territory

      t.string :page_title
      t.string :meta_content_description
      t.string :meta_tags
      t.text   :body_text

      t.timestamps
    end
  end

  def self.down
    drop_table :sub_pages
  end
end
