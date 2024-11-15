class AddEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :description
      t.datetime :when
      t.string :url
      t.string :public_email
      t.string :private_email
      t.string :state

      t.references :user
      t.references :territory
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
