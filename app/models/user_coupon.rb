# == Schema Information
#
# Table name: user_coupons
#
#  id        :integer(4)      not null, primary key
#  user_id   :integer(4)
#  coupon_id :integer(4)
#

class UserCoupon < ActiveRecord::Base
  belongs_to :user
  belongs_to :coupon
end
