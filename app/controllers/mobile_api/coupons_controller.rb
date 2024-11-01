class MobileApi::CouponsController < MobileApi::BaseController

  before_filter :set_territory

  def index
    if params[:category]
      @category = Category.find params[:category]
      bl_ids = @category.all_business_listings_with_rewards( @territory.id ).collect { |bl| bl.id }

      @coupons = Coupon.unexpired.where( "business_listing_id IN (?)", bl_ids )
    else
      @coupons =  @territory.paid_active_coupons
    end

    @categories = Category.active_categories_with_rewards_for( @territory )

    response = {
                 :categories => @categories.collect { |c| [ c.id, c.name ] },
                 :coupons   => @coupons
               }

    respond_with response
  end

end

