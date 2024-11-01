# == Schema Information
#
# Table name: addresses
#
#  id         :integer(4)      not null, primary key
#  address1   :string(255)
#  address2   :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  country    :string(255)
#  model_id   :integer(4)
#  model_type :string(255)
#  created_at :datetime
#  updated_at :datetime
#  latitude   :float
#  longitude  :float
#

class Address < ActiveRecord::Base

  geocoded_by :full_address
  after_validation :geocode, :if => :address_changed?

  belongs_to :model, :polymorphic => true

  with_options :unless => :skip_validations do |l|
    l.validates :address1,  :presence => true
    l.validates :city,      :presence => true
    l.validates :zip,       :presence => true
    l.validates :state,     :presence => true
  end

  attr_accessor :skip_validations

  def full_address
    street = [ self.address1, self.address2 ].join( " " )
    [ street, self.city, self.state, self.zip, self.country ].join( ", " )
  end

  def address_changed?
    return true if latitude.nil? || longitude.nil?

    self.address1_changed? || self.address2_changed? || self.city_changed? || self.state_changed? ||
      self.zip_changed? || self.country_changed?
  end

end
