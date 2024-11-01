class Reward < ActiveRecord::Base
  belongs_to :business_listing

  validates :description, :presence => true

  default_scope order("rewards.created_at DESC")

  scope :expired,   where( "rewards.expiration_date < ?",  Date.today )
  scope :unexpired, where( "rewards.expiration_date > ? OR rewards.never_expires = ?", Date.today, true )
  scope :active,    unexpired.joins( :business_listing ).merge( BusinessListing.paid_active )

  scope :expiring_in_30_days, where( "rewards.expiration_date >= ? AND rewards.expiration_date < ?", Time.now.to_date, Time.now.to_date + 30.days )

  def as_json( options = {} )
    json = super( :only => [ :description, :expiration_date ] )
    json[:listing] = business_listing.short_json
    json
  end
end
