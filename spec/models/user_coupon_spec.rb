# == Schema Information
#
# Table name: user_coupons
#
#  id        :integer(4)      not null, primary key
#  user_id   :integer(4)
#  coupon_id :integer(4)
#

require 'spec_helper'

describe UserCoupon do
  should_belong_to :user
  should_belong_to :coupon
end
