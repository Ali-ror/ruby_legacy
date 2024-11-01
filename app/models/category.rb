# == Schema Information
#
# Table name: categories
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  parent_id       :integer(4)
#  lft             :integer(4)
#  rgt             :integer(4)
#  territory_id    :integer(4)
#  path_name_cache :string(255)
#

class Category < ActiveRecord::Base
  acts_as_nested_set

  belongs_to :territory

  has_many :business_listing_categories, :dependent => :destroy
  has_many :business_listings, :through => :business_listing_categories

  has_many :hidden_categories, :dependent => :destroy
  
  has_friendly_id :slugger, 
                  :use_slug => true, 
                  :approximate_ascii => true,
                  :reserved_words => ["new", "edit"]
  
  validates :name,  :presence => true
  
  scope :default, where(:territory_id => nil)

  scope :territory,             lambda { |t_id| where(:territory_id => t_id) }
  scope :default_and_territory, lambda { |t_id| where("categories.territory_id IS NULL OR categories.territory_id = ?", t_id.is_a?(Class) ? t_id.id : t_id) }

  before_save :cache_category_path_name

  def self.non_hidden_default_and_territory( territory )
    hidden_categories = HiddenCategory.for_territory( territory.id ).collect { |c| c.category_id }
    Category.default_and_territory( territory.id ).where( "categories.id NOT IN (?)", hidden_categories.join(",") ).includes( :parent )
  end

  def self.roots_and_territory_categories( territory )
    if territory.nil?
      Category.all.flatten.reject { |c| !c.territory_id.nil? }
    else
      Category.non_hidden_default_and_territory( territory )
    end
  end
  
  def self.popular_categories_for( territory, limit = 15 )
    territory_categories = Category.roots_and_territory_categories( territory ).
      includes( :business_listings ).
      where( "business_listings.territory_id = ?", territory.id ).
      where( '( ( business_listings.expires > ? AND business_listings.package_type = ? ) OR ( business_listings.package_type <> ? ) )', Date.today, BusinessListing::VALID_PACKAGE_TYPES[1], BusinessListing::VALID_PACKAGE_TYPES[1] )
    
    blcs = BusinessListingCategory.
      select( "business_listing_categories.category_id, business_listing_categories.business_listing_id, count(*) as num" ).
      joins( :category, :business_listing ).includes( :category ).
      where( "business_listing_categories.category_id IN (?)", territory_categories.collect { |c| c.id } ).
      where( "business_listings.territory_id = ?", territory.id ).
      group( "business_listing_categories.category_id" ).
      order( "num DESC" ).
      limit( limit )
    
    blcs.collect { |blc| blc.category }
  end
  
  def self.active_root_categories_for( territory )
    territory_categories = Category.roots_and_territory_categories( territory ).
      joins( :business_listings ).
      where( "business_listings.territory_id = ?", territory.id ).
      where( '( ( business_listings.expires > ? AND business_listings.package_type = ? ) OR ( business_listings.package_type <> ? ) )', Date.today, BusinessListing::VALID_PACKAGE_TYPES[1], BusinessListing::VALID_PACKAGE_TYPES[1] )

    territory_categories.collect { |c| c.self_and_parents.first }.uniq.sort_by { |c| c.name }
  end
  
  def self.active_categories_with_coupons_for( territory )
    coupons = territory.paid_active_coupons.includes( :business_listing )
    bl_ids = coupons.collect { |c| c.business_listing_id }.uniq

    territory_categories = Category.non_hidden_default_and_territory( territory ).
      joins( :business_listings ).
      where( "business_listings.id IN (?)", bl_ids ).
      where( '( ( business_listings.expires > ? AND business_listings.package_type = ? ) OR ( business_listings.package_type <> ? ) )', Date.today, BusinessListing::VALID_PACKAGE_TYPES[1], BusinessListing::VALID_PACKAGE_TYPES[1] )

    cats = territory_categories.all
    cats.collect { |c| c.root }.uniq.sort_by { |c| c.name }
  end

  def self.active_categories_with_rewards_for( territory )
    rewards = territory.rewards.active.includes( :business_listing )
    bl_ids = rewards.collect { |c| c.business_listing_id }.uniq

    territory_categories = Category.non_hidden_default_and_territory( territory ).
      joins( :business_listings ).
      where( "business_listings.id IN (?)", bl_ids ).
      where( '( ( business_listings.expires > ? AND business_listings.package_type = ? ) OR ( business_listings.package_type <> ? ) )', Date.today, BusinessListing::VALID_PACKAGE_TYPES[1], BusinessListing::VALID_PACKAGE_TYPES[1] )

    cats = territory_categories.all
    cats.collect { |c| c.root }.uniq.sort_by { |c| c.name }
  end

  # Grabs the business listing for current category and it's descendants
  def all_business_listings( territory )
    t = territory.is_a?( Fixnum ) ? territory : territory.id if territory
    cat_ids = self.self_and_descendants.collect{ |c| c.id }
    blcs = BusinessListingCategory.
      where( "business_listing_categories.category_id IN (?)", cat_ids )

    bl_ids = blcs.collect { |blc| blc.business_listing_id }
    BusinessListing.
      includes( :slugs, :coupons, :comments ).
      where( "business_listings.id IN (?)", bl_ids ).
      where( "business_listings.territory_id = ?", t ).
      group( "business_listings.id" ).
      order( "business_listings.name ASC" )
  end

  def all_business_listings_with_coupons( territory )
    t = territory.is_a?( Fixnum ) ? territory : territory.id if territory

    cat_ids = self.self_and_descendants.collect{ |c| c.id }

    blcs = BusinessListingCategory.
      where( "business_listing_categories.category_id IN (?)", cat_ids )

    bl_ids = blcs.collect { |blc| blc.business_listing_id }
    listings = BusinessListing.active.
      includes( :slugs, :coupons, :comments ).
      where( "business_listings.id IN (?)", bl_ids ).
      where( "business_listings.territory_id = ?", t ).
      group( "business_listings.id" ).
      order( "business_listings.name ASC" )

    listings.reject { |bl| bl.coupons.empty? }
  end

  def all_business_listings_with_rewards( territory )
    t = territory.is_a?( Fixnum ) ? territory : territory.id if territory

    cat_ids = self.self_and_descendants.collect{ |c| c.id }

    blcs = BusinessListingCategory.
      where( "business_listing_categories.category_id IN (?)", cat_ids )

    bl_ids = blcs.collect { |blc| blc.business_listing_id }
    listings = BusinessListing.active.
      includes( :slugs, :coupons, :comments ).
      where( "business_listings.id IN (?)", bl_ids ).
      where( "business_listings.territory_id = ?", t ).
      group( "business_listings.id" ).
      order( "business_listings.name ASC" )

    listings.reject { |bl| bl.rewards.empty? }
  end

  def descendants_with_business_listings( territory_id )
    #p self.self_and_descendants
    cats = self.children.reject do |c|
      cat_ids = c.self_and_descendants.collect{ |child| child.id }

      blcs = BusinessListingCategory.
        joins( :business_listing ).
        where( "business_listing_categories.category_id IN (?)", cat_ids ).
        where( "business_listings.territory_id = ?", territory_id ).
        group( "business_listing_categories.category_id" ).merge( BusinessListing.active )

      blcs.all.size == 0
    end

    cats.uniq.sort_by { |c| c.name }
  end
      
  def hide( territory )
    HiddenCategory.create :territory => territory, :category => self
  end
  
  def seo_path
    self.path_name_cache.gsub("&nbsp;&rsaquo;&nbsp;", "/")
  end

  def self_and_parents( results = [] )
    results.insert( 0, self )
    self.root? ? results : self.parent.self_and_parents( results )
  end

  def text_category_name
    self.self_and_parents.collect { |c| c.name }.join( "&nbsp;&rsaquo;&nbsp;" ).html_safe
  end
  
  def slugger
    self.text_category_name.gsub("&nbsp;&rsaquo;&nbsp;", "/").gsub("&","").gsub(" ","-").gsub("--","-").gsub(",","").downcase
  end

  protected

  def cache_category_path_name
    self[:path_name_cache] = self.text_category_name
  end

end
