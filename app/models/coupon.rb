# == Schema Information
#
# Table name: coupons
#
#  id                  :integer(4)      not null, primary key
#  expiration_date     :date
#  restrictions        :string(255)
#  title               :string(255)
#  featured            :boolean(1)
#  position            :integer(4)
#  coupon_image        :string(255)
#  business_listing_id :integer(4)
#

class Coupon < ActiveRecord::Base
  acts_as_list

  mount_uploader :coupon_image, CouponImageUploader

  belongs_to :business_listing

  has_many :user_coupons, :dependent => :destroy
  has_many :users, :through => :user_coupons

  validates :title, :presence => true
  validates :coupon_image, :presence => true

  default_scope order("coupons.created_at DESC")

  scope :order_by_position, order("position ASC")

  scope :expired,     where("expiration_date <= ?", Time.now.to_date)
  scope :unexpired,   where("expiration_date >= ?", Time.now.to_date)

  scope :active,      unexpired.joins(:business_listing) & BusinessListing.active
  scope :active_in_mobile_apps, unexpired.where( :active_in_mobile_apps => true )

  scope :legacy,      where("title IS ? OR expiration_date IS ?", nil, nil)
  scope :expiring_in_30_days, where( "coupons.expiration_date >= ? AND coupons.expiration_date < ?", Time.now.to_date, Time.now.to_date + 30.days )

  def self.set_position(array_to_order)
    listing = find(array_to_order.first).business_listing
    count = 0
    array_to_order.each do |id|
      id = id.class == Coupon ? id.id : id
      listing.coupons.find(id).update_attribute("position",count)
      count += 1
    end
  end

  def as_json( options = {} )
    json = super( :only => [ :expiration_date, :restrictions, :title, :description ] )
    json[:listing] = business_listing.short_json
    json[:url] = coupon_image.url( :normal )

    json
  end
end
