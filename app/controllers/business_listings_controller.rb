class BusinessListingsController < ApplicationController
  before_filter :store_location, :only => [:show]

  def index
    @title = "Business Listings"

    if params[:categories].blank?
      @business_listings = BusinessListing.preferred_sort.merge( @territory.business_listings.active.order(:name) )
      @categories = Category.active_root_categories_for( @territory )
    else
      @category = Category.roots_and_territory_categories(@territory).find { |c| c.slugger == params[:categories] }
      @business_listings = BusinessListing.preferred_sort.merge( @category.all_business_listings( @territory.id ).active ) unless @category.blank?

      @categories = @category.blank? ? [] : @category.descendants_with_business_listings( @territory.id )
    end

    @business_listings = @business_listings.paginate(:per_page => 10, :page => params[:page] || 1)

    @categories = chunk_array( @categories, 3 )
  end

  def show
    @business_listing = @territory.business_listings.active_not_published.find(params[:id])

    @business_listing.increment_visits_count

    @categories = @business_listing.categories
    @category   = @categories.delete_at(0)

    @links      = @business_listing.links.where("link_type_id != ?", LinkType.find_by_name("Website").id)
    @website    = @business_listing.links.by_type("Website")

    @coupons =  @business_listing.coupons.unexpired.order_by_position
    @coupons += @business_listing.legacy_coupons

    @comments = @business_listing.comments.active.order("created_at DESC").paginate(:per_page => 10, :page => params[:page] || 1)
    @comment  = @business_listing.comments.new

    @daily_deal = @business_listing.daily_deals.for_day( Date.today ).first if @territory.deal_of_the_day_enabled

    if @business_listing && @business_listing.show_default_banners_only
      @current_header = nil
    end
  end

  def new
    @business_listing = BusinessListing.new
    @business_listing.build_address
    @business_listing.links.build
  end

  def create
    @business_listing = BusinessListing.new params[:business_listing]
    @business_listing.build_address unless @business_listing.address

    @business_listing.user_id       = current_user.id
    @business_listing.package_type  = BusinessListing::VALID_PACKAGE_TYPES[1]
    @business_listing.territory_id  = @territory.id
    @business_listing.business_tier = BusinessListing::VALID_BUSINESS_TIERS[0]

    if @business_listing.save
      Postoffice.listing_requested( @business_listing ).deliver
      redirect_to territory_root_path( @territory ), :notice => "Thank you for Submitting your application. We will review it shortly!"
    else
      render :action => :new
    end
  end

  def search
    @search = @territory.business_listings.active.search(params[:search])

    @search_terms = params[:search]["name_or_long_description_or_short_description_contains"]

    b = @territory.business_listings.active.tagged_with( @search_terms ).select( "business_listings.id" )

    ids = @search.select( "business_listings.id" ).all.collect { |bl| bl.id }
    ids += b.all.collect { |bl| bl.id }

    ids = ids.uniq

    @business_listings = BusinessListing.preferred_sort.where( "business_listings.id IN (?)", ids )
    #Rails.logger.debug @business_listings.inspect

    @business_listings = @business_listings.paginate(:per_page => 10, :page => params[:page] || 1)
    #Rails.logger.debug @business_listings.inspect
    render :template => "business_listings/index"
  end

  def tag_cloud
    @tags = Post.tag_counts_on(:tags)
  end

  def mobile_qrcode
    @business_listing = @territory.business_listings.find params[:id]

    if ENV["HOSTNAME"] == "relylocaldev.aghosted.com"
      prefix = "http://relylocaldev.aghosted.com/mobile/qr.html"
    else
      prefix = "http://m.relylocal.com/qr.html"
    end

    respond_to do |format|
      format.png { render :qrcode => "#{prefix}?locationid=#{@business_listing.territory_id}&businessid=#{@business_listing.id}&qrc" }
    end
  end
end
