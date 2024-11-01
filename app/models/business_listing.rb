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

class BusinessListing < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true, :scope => :territory

  # Add moderation and bind moderation methods to controller
  include Moderation
  moderate_controller Admin::BusinessListingsController

  acts_as_taggable

  mount_uploader :logo, LogoUploader
  mount_uploader :owner_photo, OwnerPhotoUploader
  mount_uploader :mobile_logo, MobileLogoUploader

  attr_searchable   :name, :long_description, :short_description

  has_many :business_listing_categories,
           :dependent => :destroy
  has_many :categories,
           :through => :business_listing_categories

  has_many :comments,
           :dependent => :destroy
  has_many :coupons,
           :dependent => :destroy
  has_many :links,
           :dependent => :destroy,
           :as => :model
  has_many :file_models,
           :dependent => :destroy
  has_many :pictures,
           :dependent => :destroy
  has_many :rewards,
           :dependent => :destroy
  has_many :daily_deals,
           :dependent => :destroy

  has_many :you_tube_links,
   :dependent => :destroy,
   :as => :model,
   :class_name => "Link",
   :conditions => [ "link_type_id = ?", LinkType.find_by_name( "YouTube" ).id ]

  has_many :non_you_tube_links,
   :dependent => :destroy,
   :as => :model,
   :class_name => "Link",
   :conditions => [ "link_type_id != ?", LinkType.find_by_name( "YouTube" ).id ]

  has_many :legacy_coupons,
    :dependent => :destroy

  has_one :address,
          :as => :model

  belongs_to :territory

  belongs_to :user

  has_many :daily_deals,
    :dependent => :destroy

  accepts_nested_attributes_for :business_listing_categories,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  accepts_nested_attributes_for :links,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  accepts_nested_attributes_for :address,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) }
  accepts_nested_attributes_for :file_models,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  accepts_nested_attributes_for :pictures,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  accepts_nested_attributes_for :legacy_coupons,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  accepts_nested_attributes_for :you_tube_links,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true
  accepts_nested_attributes_for :non_you_tube_links,
                                :reject_if => lambda { |a| a.reject { |k, v| k == "_destroy" }.values.all?(&:blank?) },
                                :allow_destroy => true

  validates :user_id,         :presence => true
  validates :package_type,    :presence => true
  validates :business_tier,   :presence => true
  validates :name,            :presence => true
  validates :phone,           :presence => true

  validate :at_least_one_category,
           :check_mobile_logo_dimensions,
           :check_owner_photo_dimensions

  alias_method :listing_member, :user

  VALID_PACKAGE_TYPES = [ "Feeder Listings", "Paid Listings", "Non-Member Listings" ]
  VALID_BUSINESS_TIERS = [ "100% Local", "Regionally Owned", "Non-Profit", "Locally Owned Franchise", "Independent Reseller", "National Sponsors" ]

  PENDING  = "Pending"
  APPROVED = "Approved"
  REJECTED = "Rejected"

  scope :expired,   where( 'business_listings.expires <= ?', Date.today )
  scope :active,    lambda { where( "( ( business_listings.expires >= ? AND business_listings.package_type = ? ) OR ( business_listings.package_type = ? ) OR ( business_listings.package_type = ? ) )", Date.today, VALID_PACKAGE_TYPES[1], VALID_PACKAGE_TYPES[0], VALID_PACKAGE_TYPES[2] ).approved.published }
  scope :expiring_in_30_days, where( "business_listings.expires >= ? AND business_listings.expires < ?", Time.now.to_date, Time.now.to_date + 30.days )
  scope :active_not_published, lambda { where( "( ( business_listings.expires >= ? AND business_listings.package_type = ? ) OR ( business_listings.package_type = ? ) OR ( business_listings.package_type = ? ) )", Date.today, VALID_PACKAGE_TYPES[1], VALID_PACKAGE_TYPES[0], VALID_PACKAGE_TYPES[2] ).approved }

  scope :paid_active, lambda { where( "( business_listings.expires >= ? AND business_listings.package_type = ? )", Date.today, VALID_PACKAGE_TYPES[1] ).approved.published }
  scope :paid_or_feeder_active, lambda { where( "( ( business_listings.expires >= ? AND business_listings.package_type = ? ) OR ( business_listings.package_type = ? ) )", Date.today, VALID_PACKAGE_TYPES[1], VALID_PACKAGE_TYPES[0] ).approved.published }

  scope :coupons_expiring_in_30_days, joins( :coupons ).where( "coupons.expiration_date >= ? AND coupons.expiration_date < ?", Time.now.to_date, Time.now.to_date + 30.days )
  scope :rewards_expiring_in_30_days, joins( :rewards ).where( "rewards.expiration_date >= ? AND rewards.expiration_date < ?", Time.now.to_date, Time.now.to_date + 30.days )

  scope :non_member_listings, where( :package_type => VALID_PACKAGE_TYPES[2] )
  scope :feeder_listings,     where( :package_type => VALID_PACKAGE_TYPES[0] )
  scope :paid_listings,       where( :package_type => VALID_PACKAGE_TYPES[1] )

  scope :pending,   where( :state => PENDING )
  scope :rejected,  where( :state => REJECTED )
  scope :approved,  where( :state => APPROVED )

  scope :published,   where( :published => true )
  scope :unpublished, where( "business_listings.published = false OR business_listings.published IS NULL" )

  scope :recent,    order( "created_at DESC" )
  scope :featured,  where( :featured => true )

  scope :featured_mobile, where( :featured_mobile => true )
  scope :featured_owner, where( :featured_owner => true )
  scope :has_owner_bios, where( "business_listings.owner_bio IS NOT NULL && business_listings.owner_bio <> ''" )

  scope :resellers, where( :reward_reseller => true )

  scope :preferred_sort, order( "case	when business_listings.package_type = 'Paid Listings' then 1 when business_listings.package_type = 'Feeder Listings' then 2	when business_listings.package_type = 'Non-Member Listings' then 3 end" )

  after_update :handle_update

  before_create :set_state_to_approved

  before_save :strip_mobile_description

  attr_accessor :user_proxy,
                :mobile_logo_upload_width,
                :mobile_logo_upload_height,
                :owner_photo_upload_width,
                :owner_photo_upload_height

  def user_proxy
    user.nil? ? "" : "#{user.to_label} (#{user.email})"
  end

  def set_featured
    if self.featured
      self.featured = false
    else
      self.featured = true
      self.featured_date = Date.today
    end

    self.save
  end

  def featured_text
    if self.featured
      "Yes (#{self.featured_date})"
    else
      "No"
    end
  end

  def average_rating
    comments = self.comments.active
    unless comments.blank?
      comments.sum(:rating)/comments.count
    else
      return 0
    end
  end

  def belongs_to?(user)
    self.user == user
  end

  def info
    address = self.address
    html = "<h2>#{self.name}</h2>"
    html += "<p><br/>"
    html += "#{address.address1}"
    html += "<br/>" if address.address2.blank?
    html += ", #{address.address2}<br/>" unless address.address2.blank?

    html += "#{address.city}"    unless address.city.blank?
    html += ", #{address.state}" unless address.state.blank?
    html += ", #{address.zip}"   unless address.zip.blank?

    html += "</p>"
    return html
  end

  def show_map?
    self.hide_map != true && !self.address.blank?
  end

  def increment_visits_count
    self.visits = 0 if self.visits.nil?
    self.visits += 1
    self.save( :validate => false )
  end

  def feeder_listing?
    self.package_type == VALID_PACKAGE_TYPES[0]
  end

  def paid_listing?
    self.package_type == VALID_PACKAGE_TYPES[1]
  end

  def non_member_listing?
    self.package_type == VALID_PACKAGE_TYPES[2]
  end

  def self.search_by(keyword)
    t = self.arel_table
    self.where( t[:name].matches( "%#{keyword}%" ) )
  end

  def published?
    self.published ? "Yes" : "No"
  end

  def publish!
    self.update_attribute(:published, true)
  end

  def unpublish!
    self.update_attribute(:published, false)
  end

  def short_version
    {
      :id                => id,
      :url               => logo.url( :partner ),
      :name              => name,
      :short_description => short_description,
      :rewards           => !rewards.active.empty?,
      :coupons           => !coupons.active.empty?
    }
  end
  alias_method :short_json, :short_version

  def long_json
    json = {
      :email             => email,
      :id                => id,
      :logo              => logo.url( :partner ),
      :mobile_logo       => mobile_logo.url( :normal ),
      :name              => name,
      :long_description  => ( mobile_friendly_description.blank? ? short_description : mobile_friendly_description ),
      :phone             => phone,
      :average_rating    => average_rating,
      :hide_address      => hide_address,
      :hide_map          => hide_map,
      :hours             => operating_hours,
      :territory_name    => territory.name
    }

    links.each do |l|
      json[:links] ||= []
      json[:links] << { :type_name => l.type_name, :url => l.url }
    end

    json[:logo] = logo.url( :partner )

    json[:coupons] = !coupons.active.active_in_mobile_apps.empty?
    json[:photos] = !pictures.active.empty?
    json[:downloads] = !file_models.empty?
    json[:meet_the_owner] = !owner_bio.blank?
    json[:address] = {
      :address1 => address.address1,
      :address2 => address.address2,
      :city     => address.city,
      :state    => address.state,
      :zip      => address.zip,
      :county   => address.country
    }

    json
  end

  protected

  def at_least_one_category
    if business_listing_categories.empty? && categories.empty? && published
      errors.add :base, "There must be at least one category on this business listing."
    end
  end

  def check_mobile_logo_dimensions
    #Rails.logger.debug "-------------------------------------"
    if mobile_logo? && mobile_logo_upload_width
      #Rails.logger.debug "-------------------------------------"
      #Rails.logger.debug "mobile logo upload dimensions: #{self.mobile_logo_upload_width}x#{self.mobile_logo_upload_height}".inspect
      #Rails.logger.debug (!( self.mobile_logo_upload_width == 114 && self.mobile_logo_upload_height == 114 )).inspect
      #Rails.logger.debug ( self.mobile_logo_upload_width == 114 ).inspect
      #Rails.logger.debug ( self.mobile_logo_upload_height == 114 ).inspect
      errors.add :mobile_logo, "Dimensions of uploaded Mobile logo must be exactly 114x114." if !( self.mobile_logo_upload_width == 114 && self.mobile_logo_upload_height == 114 )
    end
  end

  def check_owner_photo_dimensions
    if owner_photo? && owner_photo_upload_width
      errors.add :owner_photo, "Dimensions of uploaded Owner Photo must be exactly 140x160." if !( self.owner_photo_upload_width == 140 && self.owner_photo_upload_height == 160 )
    end
  end

  def handle_update
    if self.state_changed? && self.state_change[1] == APPROVED
      Postoffice.listing_approved(self).deliver
    end
  end

  def set_state_to_approved
    self.state = APPROVED
  end

  def strip_mobile_description
    #Rails.logger.debug "-------------------------------------strip"
    #Rails.logger.debug self.mobile_friendly_description.inspect
    self.mobile_friendly_description = Sanitize.clean( self.mobile_friendly_description, Sanitize::Config::RESTRICTED ) unless mobile_friendly_description.nil?
    #Rails.logger.debug self.mobile_friendly_description.inspect
  end

end
