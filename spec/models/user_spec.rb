# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  first_name           :string(255)
#  last_name            :string(255)
#  phone                :string(255)
#  fax                  :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  login                :string(255)
#  global_admin         :boolean(1)      default(FALSE)
#  opt_in_newsletter    :boolean(1)      default(FALSE)
#  authentication_token :string(255)
#

require 'spec_helper' 

describe User do
  before(:each) do
    @user = Factory.create(:user)
  end
  
  should_have_one :address
  
  should_have_many :user_territories, :dependent => :destroy
  should_have_many :territories, :through => :user_territories
  
  should_have_many :user_coupons, :dependent => :destroy
  should_have_many :coupons,  :through => :user_coupons

  should_have_many :user_territory_local_admins,
                   :dependent => :destroy,
                   :class_name => "UserTerritory",
                   :conditions => { :local_admin => true }
  
  should_have_many :local_admins,
                   :through => :user_territory_local_admins,
                   :class_name => "Territory",
                   :source => :territory

  should_have_many :business_listings
  
  should_validate_presence_of :first_name
  should_validate_presence_of :last_name
  
  it "#is_territory_admin? should show a user as admin over a territory or not" do
    @territory = Factory.create(:territory)
    @user.is_territory_admin?.should == false      
    
    @user.territories << @territory
    @user.user_territories.first.update_attribute(:local_admin, true)
    @user.is_territory_admin?.should == true
  end
  
  it "#is_territory_admin_for?(territory) should let you know if a user is admin over a territory" do
    territory = Factory.create(:territory)
    @user.is_territory_admin_for?(territory).should == false
    
    @user.territories << territory
    @user.user_territories.first.update_attribute(:local_admin, true)
    @user.is_territory_admin_for?(territory).should == true
  end
end
