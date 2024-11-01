class MobileApi::BusinessListingsController < MobileApi::BaseController

  before_filter :set_territory

  def index
    if params[:category].blank?
      @business_listings = @territory.business_listings.active.preferred_sort.order(:name)
      @categories = Category.active_root_categories_for( @territory )
    else
      @category = Category.find params[:category]
      @business_listings = BusinessListing.preferred_sort.merge( @category.all_business_listings( @territory.id ).active ) unless @category.blank?

      @categories = @category.blank? ? [] : @category.descendants_with_business_listings( @territory.id )
    end

    response = {
     :categories => @categories.collect { |c| [ c.id, c.name ] },
     :listings   => @business_listings.collect { |bl| bl.short_version }
   }

    respond_with response
  end

  def show
    @business_listing = @territory.business_listings.active_not_published.find(params[:id])
    @business_listing.increment_visits_count

    json = @business_listing.long_json

    json[:daily_deals] = !@business_listing.daily_deals.for_day( Date.today ).empty?
    json[:rewards]     = !@business_listing.rewards.active.empty?

    respond_with json
  end

  def meet_the_owner
    @business_listing = @territory.business_listings.active_not_published.find(params[:id])
    json = @business_listing.long_json

    json[:meet_the_owner] = {
      :bio   => @business_listing.owner_bio,
      :name  => @business_listing.owner_name,
      :photo => @business_listing.owner_photo.url
    }

    respond_with json
  end

  def files
    @business_listing = @territory.business_listings.active_not_published.find(params[:id])
    json = @business_listing.long_json

    json[:files] = @business_listing.file_models.collect do |fm|
      {
        :title => fm.title,
        :url   => fm.file_attachment.url
      }
    end

    respond_with json
  end

  def photos
    @business_listing = @territory.business_listings.active_not_published.find(params[:id])
    json = @business_listing.long_json

    json[:pictures] = @business_listing.pictures.active.collect do |p|
      {
        :caption => p.caption,
        :url     => p.picture.url(:normal)
      }
    end

    respond_with json
  end

  def coupons
    @business_listing = @territory.business_listings.active_not_published.find(params[:id])
    json = @business_listing.long_json

    json[:coupons] = @business_listing.coupons.active.active_in_mobile_apps

    respond_with json
  end

  def rewards
    @business_listing = @territory.business_listings.active_not_published.find(params[:id])
    json = @business_listing.long_json

    json[:rewards] = @business_listing.rewards.active

    respond_with json
  end

  def search
    search = @territory.business_listings.active.search params[:search]

    search_terms = params[:search]["name_or_long_description_or_short_description_contains"]

    b = @territory.business_listings.active.tagged_with( search_terms ).select( "business_listings.id" )

    ids = search.select( "business_listings.id" ).all.collect { |bl| bl.id }
    ids += b.all.collect { |bl| bl.id }

    ids = ids.uniq

    business_listings = BusinessListing.preferred_sort.where( "business_listings.id IN (?)", ids )

    response = {
      :listings => business_listings.collect { |bl| bl.short_version }
    }

    respond_with response
  end

end