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

require 'spec_helper'

describe Coupon do
  before(:each) do
    @biz_listing = Factory.create(:business_listing)
    @coupon = Factory.create(:coupon, :business_listing => @biz_listing)
  end
  
  should_belong_to :business_listing

  should_have_many :user_coupons,
                   :dependent => :destroy

  should_have_many :users,
                   :through => :user_coupons

  should_validate_presence_of :coupon_image
  should_validate_presence_of :title
  
  it "Coupon#set_position([coupon1_id, coupon2_id]) should order the coupon positions" do
    @coupon2 = Factory.create(:coupon, :business_listing => @biz_listing)
    @coupon3 = Factory.create(:coupon, :business_listing => @biz_listing)
    @coupon4 = Factory.create(:coupon, :business_listing => @biz_listing)
    
    Coupon.set_position([@coupon, @coupon2, @coupon3, @coupon4])
    @biz_listing.coupons.order_by_position.should == [@coupon, @coupon2, @coupon3, @coupon4]

    Coupon.set_position([@coupon, @coupon4, @coupon2, @coupon3])
    @biz_listing.coupons.order_by_position.should == [@coupon, @coupon2, @coupon3, @coupon4]
  end
end