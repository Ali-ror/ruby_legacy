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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login, :last_name, :first_name, 
                  :address_attributes, :user_territories_attributes, :opt_in_newsletter

  has_one :address, :as => :model

  has_many :user_territories, :dependent => :destroy
  has_many :territories, :through => :user_territories

  has_many :user_territory_local_admins,
           :dependent => :destroy,
           :class_name => "UserTerritory",
           :conditions => { :local_admin => true }
    
  has_many :local_admins,
           :through => :user_territory_local_admins,
           :class_name => "Territory",
           :source => :territory

  has_many :user_coupons, :dependent => :destroy
  has_many :coupons, :through => :user_coupons
  has_many :business_listings
  has_many :comments, :dependent => :destroy

  has_many :user_daily_deals,
           :dependent => :destroy
  has_many :daily_deals,
           :through => :user_daily_deals
  
  accepts_nested_attributes_for :address, 
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
                                
  accepts_nested_attributes_for :user_territories, 
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } },
                                :allow_destroy => true
  
  validates :first_name, :presence => true
  validates :last_name,  :presence => true
  
  scope :global_admins,     where(:global_admin => true)  
  scope :site_users,        where(:global_admin => false)
  
  scope :order_by_email,  order("email")
  
  # Build search using AREL
  class << self    
    def search_with(options={})
      search_by(options[:keyword]).name_starts_with(options[:starts_with])
    end
    
    def name_starts_with(letter)
      t = self.arel_table
      self.where(t[:first_name].matches("#{letter}%"))
    end
    
    def search_by(keyword)
      t = self.arel_table
      self.where(
        t[:first_name].matches("%#{keyword}%").or(t[:last_name].matches("%#{keyword}%")).or(t[:email].matches("%#{keyword}%"))
      )
    end
  end
  
  # User Name
  def full_name
    "#{first_name} #{last_name}"
  end
  
  # Readable Alias Check
  def is_global_admin?
    self.global_admin
  end

  def is_territory_admin?
    !self.local_admins.blank?
  end
  
  def is_listing_manager?
    !self.business_listings.empty?
  end
  
  def is_admin?
    is_territory_admin? || is_global_admin?
  end
  
  # Check if user is admin over a specific territory
  def is_territory_admin_for?(territory)
    territory.local_admins.include?(self)
  end
  
  # Check if user is listing manager in a specific territory
  def is_listing_manager_in?( territory )
    !self.business_listings.where( :territory_id => territory.id ).empty?
  end

  # Check if user is listing manager for a specific business listing
  def is_listing_manager_for?( business_listing )
    self.business_listings.include?( business_listing )
  end

  # Readable label
  def to_label
    "#{first_name} #{last_name}"
  end

  def self.local_admin_users( territory = nil )
    rel = UserTerritory.where( :local_admin => true ).select( "user_territories.user_id" )
    rel = rel.where( :territory_id => territory.id ) if territory

    ids = rel.all.collect { |ut| ut.user_id }.uniq
    where( "users.id IN (?)", ids )
  end

  def self.business_members( territory = nil )
    rel = BusinessListing.where( "business_listings.user_id IS NOT NULL" ).select( "business_listings.user_id" )
    rel = rel.where( "business_listings.territory_id = ?", territory.id ) if territory

    ids = rel.all.collect { |ut| ut.user_id }.uniq
    where( "users.id IN (?)", ids )
  end

  def self.generic_users
    ids = UserTerritory.where( :local_admin => true ).select( "user_territories.user_id" ).all.collect { |ut| ut.user_id }
    ids += BusinessListing.where( "business_listings.user_id IS NOT NULL" ).select( "business_listings.user_id" ).all.collect { |ut| ut.user_id }
    ids += User.global_admins.collect { |u| u.id }

    ids = ids.flatten.uniq.reject { |i| i.nil? }

    where( "users.id NOT IN (?)", ids )
  end

  def self.generate_daily_deal_emails
    User.includes(:user_territories).all.each do |u|
      u.user_territories.each do |ut|
        if ut.subscribe_daily_deal_email && ut.territory.deal_of_the_day_enabled
          deal = ut.territory.daily_deals.for_day( Date.today )
          if !deal.empty?
            begin
              Postoffice.daily_deal_email( deal.first, ut ).deliver
            rescue
            end
          end
        end
      end
    end
  end

end
