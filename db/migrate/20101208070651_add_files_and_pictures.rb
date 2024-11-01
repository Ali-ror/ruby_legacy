class AddFilesAndPictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string :caption
      t.references :business_listing

      t.timestamps
    end

    create_table :file_models do |t|
      t.string :title
      t.references :business_listing

      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
    drop_table :file_models
  end
end
