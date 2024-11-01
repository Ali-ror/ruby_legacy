# == Schema Information
#
# Table name: territories
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  tracking_code           :text
#  cached_slug             :string(255)
#  featured_link           :string(255)
#  page_title              :string(255)
#  meta_description        :string(255)
#  meta_tags               :string(255)
#  hide_events_calendar    :boolean(1)
#  rewards_enabled         :boolean(1)
#  deal_of_the_day_enabled :boolean(1)
#  brand_name              :string(255)
#  brand_default_logo      :string(255)
#  territory_type          :string(255)
#

class Territory < ActiveRecord::Base

  mount_uploader :brand_default_logo, LogoUploader

  has_many :user_territories, :dependent => :destroy
  has_many :users, :through => :user_territories

  has_many :categories

  has_many :user_territory_local_admins,
           :dependent => :destroy,
           :class_name => "UserTerritory",
           :conditions => { :local_admin => true }

  has_many :local_admins,
           :through => :user_territory_local_admins,
           :class_name => "User",
           :source => :user

  has_many :business_listings, :dependent => :destroy
  has_many :comments,    :through => :business_listings
  has_many :pictures,    :through => :business_listings
  has_many :daily_deals, :through => :business_listings
  has_many :rewards,     :through => :business_listings

  has_many :coupons,         :through => :business_listings
  has_many :legacy_coupons,  :through => :business_listings

  has_many :banners,   :dependent => :destroy
  has_many :headers,   :dependent => :destroy
  has_many :sub_pages, :dependent => :destroy
  has_many :events,    :dependent => :destroy

  has_many :links, :as => :model

  has_many :affiliates, :dependent => :destroy

  has_many :cities, :dependent => :destroy

  has_many :territory_texts, :dependent => :destroy, :autosave => true

  has_friendly_id :slugger,
                  :use_slug => true,
                  :approximate_ascii => true,
                  :reserved_words => ["new", "edit"]

  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :cities,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  accepts_nested_attributes_for :links,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  accepts_nested_attributes_for :affiliates,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  accepts_nested_attributes_for :territory_texts,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  default_scope order( 'name' )

  validates :name,             :presence => true
  validates :featured_link,    :length => { :maximum => 255 }
  validates :page_title,       :length => { :maximum => 255 }
  validates :meta_description, :length => { :maximum => 255 }
  validates :meta_tags,        :length => { :maximum => 255 }

  validates :affiliates,       :length => { :maximum => 5, :message => "There can be a maximum of 5 affiliates." }
  validate :validate_rewards_and_deals

  validates :territory_type,     :presence => true
  validates :brand_name,         :presence => true, :if => lambda { |t| t.territory_type == VALID_TERRITORY_TYPES[1] }
  validates :brand_default_logo, :presence => true, :if => lambda { |t| t.territory_type == VALID_TERRITORY_TYPES[1] }

  accepts_nested_attributes_for :user_territory_local_admins,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true

  before_create :apply_and_configure_territory_defaults

  VALID_TERRITORY_TYPES = [ "Private Owner", "Organization" ]

  def description
    "#{name}"
  end

  # Create a slug for territory to include state
  def slugger
    state = self.cities.first.state if self.cities.first
    if state
      "#{name.to_slug}-#{state.to_slug}".downcase
    else
      "#{name.to_slug}".downcase
    end
  end

  # Search and filter features
  class << self
    def search_with(options={})
      search_by(options[:keyword]).name_starts_with(options[:starts_with])
    end

    def name_starts_with(letter)
      t = self.arel_table
      letter.blank? ? scoped : self.where(t[:name].matches("#{letter}%"))
    end

   def search_by(keyword)
     t = self.arel_table
     self.where(t[:name].matches("%#{keyword}%"))
   end
  end

  def admin_emails
    self.local_admins.collect(&:email)
  end

  def paid_active_coupons
    bl_ids = business_listings.paid_active.collect { |bl| bl.id }
    Coupon.unexpired.where( "business_listing_id IN (?)", bl_ids )
  end

  def active_legacy_coupons
    bl_ids = business_listings.active.collect { |bl| bl.id }
    LegacyCoupon.where( "business_listing_id IN (?)", bl_ids )
  end

  def has_tracking_code?
    !self.tracking_code.blank? && self.tracking_code != "tracking code"
  end

  def paid_active_rewards
    bl_ids = business_listings.paid_active.collect { |bl| bl.id }
    Reward.unexpired.where( "business_listing_id IN (?)", bl_ids )
  end

  def reset_default_text
    TerritoryText::CONTENTS_TYPES.each do |s|
      eval "self.#{s.to_s} = nil"
    end

    apply_and_configure_territory_defaults
    save( :validate => false )
  end

  # Territory texts methods
  TerritoryText::CONTENTS_TYPES.each do |t|
    define_method t do
      #Rails.logger.info "---------------------------------------#{t}.get"
      tx = self.territory_texts.detect { |tt| tt.contents_type == t.to_s }
      #Rails.logger.info '---------------------------------------'
      #Rails.logger.info tx.inspect
      tx.nil? ? nil : tx.contents
    end
    define_method "#{t.to_s}=" do |contents|
      #Rails.logger.info "---------------------------------------#{t}.set"
      #Rails.logger.info contents.inspect
      tx = self.territory_texts.detect { |tt| tt.contents_type == t.to_s }
      tx = self.territory_texts.build( :contents_type => t.to_s ) if tx.nil?
      tx.contents = contents
      #Rails.logger.info tx.inspect
    end
    define_method "#{t.to_s}_proxy".to_sym do
      #Rails.logger.info "---------------------------------------#{t}_proxy.get"
      tx = self.territory_texts.detect { |tt| tt.contents_type == t.to_s }
      #Rails.logger.info '---------------------------------------'
      #Rails.logger.info tx.inspect
      tx.nil? ? nil : tx.contents
    end
    define_method "#{t.to_s}_proxy=" do |contents|
      #Rails.logger.info "---------------------------------------#{t}_proxy.set"
      #Rails.logger.info contents.inspect
      tx = self.territory_texts.detect { |tt| tt.contents_type == t.to_s }
      tx = self.territory_texts.build( :contents_type => t.to_s ) if tx.nil?
      tx.contents = contents
      #Rails.logger.info tx.inspect
    end
  end

  def private_label
    self.territory_type == VALID_TERRITORY_TYPES[1]
  end

  protected

  def apply_and_configure_territory_defaults
    defaults = YAML.load_file("#{Rails.root}/config/national_defaults.yml")[Rails.env]

    prefix = self.territory_type == VALID_TERRITORY_TYPES[1] ? "private_" : ""

    TerritoryText::CONTENTS_TYPES.each do |s|
      self.send( "#{s}=", defaults["#{prefix}#{s}"].gsub( '(territory_name)', self.name ).gsub( '(brand_name)', self.brand_name ) )
    end
  end

  def validate_rewards_and_deals
    errors.add( :deal_of_the_day_enabled, "can only be enabled if RelyLocal Rewards are enabled" ) if ( self.deal_of_the_day_enabled && !self.rewards_enabled )
  end

end
