class AddCarrierwave < ActiveRecord::Migration
  def self.up
    drop_table :attachments

    add_column :banners, :banner, :string
    add_column :headers, :header, :string
    add_column :business_listings, :logo, :string
    add_column :business_listings, :background_image, :string
    add_column :file_models, :file_attachment, :string
    add_column :pictures, :picture, :string
    add_column :coupons, :coupon_image, :string

    create_table :affiliates do |t|
      t.string :name
      t.string :logo
      t.integer :position

      t.references :territory

      t.timestamps
    end
  end

  def self.down
    create_table :attachments do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.string :context

      t.references :model, :polymorphic => true

      t.timestamps
    end

    remove_column :banners, :banner
    remove_column :headers, :header
    remove_column :business_listings, :logo
    remove_column :business_listings, :background_image
    remove_column :file_models, :file_attachment
    remove_column :pictures, :picture
    remove_column :coupons, :coupon_image

    drop_table :affiliates
  end
end
