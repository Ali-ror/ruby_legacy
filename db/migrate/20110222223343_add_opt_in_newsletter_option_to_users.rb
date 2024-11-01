class AddOptInNewsletterOptionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :opt_in_newsletter, :boolean, :default => false
  end

  def self.down
    remove_column :users, :opt_in_newsletter
  end
end