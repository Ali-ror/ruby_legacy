# == Schema Information
#
# Table name: legacy_coupons
#
#  id                  :integer(4)      not null, primary key
#  legacy_coupon       :string(255)
#  business_listing_id :integer(4)
#

class LegacyCoupon < ActiveRecord::Base
  belongs_to :business_listing

  mount_uploader :legacy_coupon, LegacyCouponUploader
end
