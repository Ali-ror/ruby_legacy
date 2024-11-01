class Admin::CouponsController < Admin::AdministrationController
  before_filter :collection, :only => [:index]
  
  belongs_to :business_listing
    
  authorize_resource
  
  def create
    create! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_coupons_path( @territory, @business_listing ) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_coupons_path( @territory, @business_listing ) }
    end
  end
  
  def sort
    Coupon.set_position(params[:coupon])
    render :text => "Success!", :status => 200
  end

  protected

  def collection
    @coupons = end_of_association_chain.order_by_position.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end
end