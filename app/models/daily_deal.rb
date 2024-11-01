class DailyDeal < ActiveRecord::Base
  
  mount_uploader :deal_image, DailyDealImageUploader

  belongs_to :business_listing

  has_many :user_daily_deals,
           :dependent => :destroy
  has_many :users,
           :through => :user_daily_deals

  validates :title,               :presence => true
  validates :deal_image,          :presence => true
  validates :business_listing_id, :presence => true

  scope :expired,   where( "daily_deals.expiration_date < ?",  Date.today )
  scope :unexpired, where( "daily_deals.expiration_date > ?",  Date.today  )
  scope :active,    unexpired.joins( :business_listing ).merge( BusinessListing.paid_active )

  scope :for_month, lambda { |date| where( "deal_date >= ?", date.beginning_of_month ) }
  scope :for_day,   lambda { |date| where( :deal_date => date ) }

  attr_accessor :business_listing_proxy

  def business_listing_proxy
    business_listing.nil? ? "" : business_listing.name
  end

  def as_json( options = {} )
    json = super( :except => [ :id, :created_at, :updated_at, :user_id, :territory_id ] )
    json[:listing] = business_listing.long_json
    json[:url] = deal_image.url( :normal )
    json
  end

end
