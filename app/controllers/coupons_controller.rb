class CouponsController < ApplicationController
  before_filter :find_coupon, :except => [:index]

  def index
    #Rails.logger.debug "-------------------------------------"
    if params[:categories]
      @category = Category.non_hidden_default_and_territory(@territory).find { |c| c.slugger == params[:categories] }

      bl_ids = @category.all_business_listings_with_coupons( @territory.id ).collect { |bl| bl.id }

      @coupons = Coupon.unexpired.where( "business_listing_id IN (?)", bl_ids )
      @coupons = @coupons.paginate(:per_page => 15, :page => params[:page] || 1)

#      @categories = @category.children_with_business_listings_and_coupons( @territory.id )
      #Rails.logger.debug @categories.inspect
    else
      @coupons =  @territory.paid_active_coupons
      @coupons += @territory.active_legacy_coupons
      @coupons = @coupons.paginate(:per_page => 15, :page => params[:page] || 1)

#      @categories = Category.active_categories_with_coupons_for( @territory )
      #Rails.logger.debug @categories.inspect
    end

    @categories = Category.active_categories_with_coupons_for( @territory )
    @categories = chunk_array( @categories, 3 )
    #Rails.logger.debug @categories.inspect
  end

  def show
    render :template => "coupons/show", :layout => "print"
  end
  
  private
  
  def find_coupon
    @business_listing = @territory.business_listings.active.find(params[:business_listing_id])
    
    @coupon = @business_listing.coupons.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @coupon = @business_listing.legacy_coupons.find(params[:id])
  end
end