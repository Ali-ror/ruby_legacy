class CreateModels < ActiveRecord::Migration

  def self.up
    create_table :territories do |t|
      t.string :name
      t.string :primary_zip_code

      t.timestamps
    end

    create_table :user_territories do |t|
      t.references :user
      t.references :territory

      t.boolean :local_admin
      t.boolean :subscribe_email_list

      t.timestamps
    end

    create_table :banners do |t|
      # has_one attachment for the banner image

      t.references :territory
      t.boolean :active

      t.timestamps
    end

    create_table :headers do |t|
      # has_one attachment for the header image

      t.references :territory
      t.boolean :credit

      t.timestamps
    end

    create_table :business_listings do |t|
      t.string :name
      t.string :owner
      t.date :expires
      t.string :state
      t.boolean :featured
      t.date :featured_date

      t.string :operating_hours
      t.string :phone
      t.string :fax
      t.string :skype

      # has_one :address
      # has_many :links
      # has_one attachment for logo

      t.timestamps
    end

    create_table :attachments do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.string :context

      t.references :model, :polymorphic => true

      t.timestamps
    end

    create_table :addresses do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.references :model, :polymorphic => true

      t.timestamps
    end

    create_table :links do |t|
      t.string :url
      t.references :link_type

      t.references :model, :polymorphic => true

      t.timestamps
    end

    create_table :link_types do |t|
      t.string :type

      t.timestamps
    end

    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
    end

    create_table :business_listing_categories do |t|
      t.references :category
      t.references :business_listing

      t.timestamp
    end

    create_table :comments do |t|
      t.text :comment
      t.string :state
      t.integer :rating

      t.references :business_listing

      t.timestamp
    end

    create_table :coupons do |t|
      t.date :expiration_date
      t.integer :x_amount
      t.integer :x_type
      t.integer :y_amount
      t.integer :y_type
      t.string :custom
      t.string :details
      t.string :background_color
      t.string :font
      t.string :font_color
      t.integer :tally
      t.boolean :featured
      t.integer :position

      # has_one attachment for logo
      # has_one attachment for background_image

      t.timestamp
    end

  end

  def self.down
    drop_table :territories
    drop_table :user_territories
    drop_table :banners
    drop_table :headers
    drop_table :attachments
    drop_table :coupons
    drop_table :links
    drop_table :link_types
    drop_table :business_listings
    drop_table :business_listing_categories
    drop_table :categories
    drop_table :comments
    drop_table :addresses
  end
  
end
