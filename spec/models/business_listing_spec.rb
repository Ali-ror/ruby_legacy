# == Schema Information
#
# Table name: business_listings
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  expires           :date
#  state             :string(255)
#  featured          :boolean(1)
#  featured_date     :date
#  operating_hours   :string(255)
#  phone             :string(255)
#  fax               :string(255)
#  skype             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  territory_id      :integer(4)
#  package_type      :string(255)
#  short_description :string(255)
#  long_description  :text
#  hide_address      :boolean(1)
#  hide_map          :boolean(1)
#  email             :string(255)
#  user_id           :integer(4)
#  visits            :integer(4)
#  logo              :string(255)
#  background_image  :string(255)
#  business_tier     :string(255)
#

require 'spec_helper'

describe BusinessListing do
  should_have_many :business_listing_categories,
                   :dependent => :destroy
  should_have_many :categories,
                   :through => :business_listing_categories

  should_have_many :comments,
                   :dependent => :destroy

  should_have_one :address,
                  :as => :model

  should_have_many :coupons,
                   :dependent => :destroy

  should_have_many :links,
                   :dependent => :destroy,
                   :as => :model

  should_have_many :file_models,
                   :dependent => :destroy

  should_have_many :pictures,
                   :dependent => :destroy

  should_belong_to :territory

  should_belong_to :user

  should_accept_nested_attributes_for :business_listing_categories,
                                      :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) }
  should_accept_nested_attributes_for :links,
                                      :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) }
  should_accept_nested_attributes_for :address,
                                      :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) }
  should_accept_nested_attributes_for :file_models,
                                      :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) }
  should_accept_nested_attributes_for :pictures,
                                      :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) }

  should_validate_presence_of :user_id
  should_validate_presence_of :package_type
  should_validate_presence_of :name
  should_validate_presence_of :phone

  it "validates that at least one category is assigned" do
    bl = Factory.build :business_listing
    bl.business_listing_categories.clear

    bl.valid?.should be_false
    bl.errors.full_messages.first.should include "must be at least one category"

    c = Factory.create :category
    bl.business_listing_categories.build :category => c

    bl.valid?.should be_true
  end

  it "sets it's state to pending when created" do
    bl = Factory.build :business_listing
    c = Factory.create :category
    bl.business_listing_categories.build :category => c

    bl.state.should be_nil
    bl.save.should be_true

    bl.state.should eql BusinessListing::PENDING
  end


end
