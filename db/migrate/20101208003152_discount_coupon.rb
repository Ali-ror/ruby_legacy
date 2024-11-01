class DiscountCoupon < ActiveRecord::Migration
  def self.up
    drop_table :coupons

    create_table :coupons do |t|
      t.date    :expiration_date
      t.string  :description
      t.string  :title
      t.boolean :featured
      t.integer :position

      # has_one attachment for background_image
      t.timestamp
    end
  end

  def self.down
    drop_table :coupons

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
end
