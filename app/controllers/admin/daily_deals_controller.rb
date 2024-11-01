class Admin::DailyDealsController < Admin::AdministrationController
  before_filter :collection, :only => [:index]

  belongs_to :territory

  load_and_authorize_resource

  def create
    create! do |success, failure|
      success.html { redirect_to admin_territory_daily_deals_path( @territory ) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to admin_territory_daily_deals_path( @territory ) }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to admin_territory_daily_deals_path( @territory ) }
    end
  end

  protected

  def resource
    @daily_deals =DailyDeal.find(params[:id])
  end

  def collection
    #@territory = Territory.find( params[:territory_id] )
    #@rewards = @business_listing.rewards
    @date = params[:date] ? Time.parse( params[:date] ).to_date : Date.today
    @daily_deals = @territory.daily_deals.for_month( @date )
  end
end