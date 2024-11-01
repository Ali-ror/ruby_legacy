# == Schema Information
#
# Table name: territories
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  discovery_text          :text
#  save_text               :text
#  connect_text            :text
#  can_rely_text           :text
#  tracking_code           :text
#  cached_slug             :string(255)
#  featured_link           :string(255)
#  local_businesses        :text
#  local_coupons           :text
#  local_jobs              :text
#  what_is_relylocal       :text
#  list_your_businesses    :text
#  show_your_support       :text
#  contact_us              :text
#  page_title              :string(255)
#  meta_description        :string(255)
#  meta_tags               :string(255)
#  advertise_with_us       :text
#  hide_events_calendar    :boolean(1)
#  rewards_text            :text
#  rewards_enabled         :boolean(1)
#  deal_of_the_day_enabled :boolean(1)
#  brand_name              :string(255)
#  brand_default_logo      :string(255)
#  territory_type          :string(255)
#

require 'spec_helper'

describe Territory do
  before(:each) do
    @territory        = Factory.create(:territory)
    @territory_admin  = Factory.create(:user)
    @territory_admin.user_territories.create(:territory => @territory, :local_admin => true)
  end
  
  should_have_many :user_territories,
                   :dependent => :destroy
  
  should_have_many :users,
                   :through => :user_territories

  should_have_many :user_territory_local_admins,
                   :dependent => :destroy,
                   :class_name => "UserTerritory",
                   :conditions => { :local_admin => true }

  should_have_many :local_admins,
                   :through => :user_territory_local_admins,
                   :class_name => "User",
                   :source => :user

  should_have_many :business_listings,
                   :dependent => :destroy

  should_have_many :categories

  should_have_many :banners,
                   :dependent => :destroy

  should_have_many :headers,
                   :dependent => :destroy

  should_have_many :links, :as => :model

  should_have_many :affiliates, :dependent => :destroy

  should_validate_presence_of :name

  should_accept_nested_attributes_for :user_territory_local_admins,
                                      :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) }

  
  it "returns a description of the territory" do
    territory = Factory.build :territory, :name => "Plano"
    territory.description.should eql "Plano"
  end
  
end
