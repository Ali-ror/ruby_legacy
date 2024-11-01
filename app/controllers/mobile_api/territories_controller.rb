class MobileApi::TerritoriesController < MobileApi::BaseController
  include AnalyticsHelper

  def index
    cities = City.with_territory

    if params[:state]
      cities = cities.includes( :territory ).where( :state => params[:state] )
      cities = cities.sort_by { |c| c.city }.collect { |c| [ c.city, c.territory.id, c.territory.name ] }
      respond_with cities
    else
      respond_with cities.map(&:state).uniq.sort
    end
  end

  def show
    territory         = Territory.find params[:id]
    featured_listings = territory.business_listings.active.featured_mobile.shuffle
    categories        = Category.active_root_categories_for( territory )

    response = {
                 :territory_id         => territory.id,
                 :territory_name       => territory.name,
                 :daily_deal_activated => territory.deal_of_the_day_enabled ? true : false,
                 :rewards_activated    => territory.rewards_enabled ? true : false,
                 :events_enabled       => !territory.hide_events_calendar,
                 :categories           => categories.collect { |c| [ c.id, c.name ] },
                 :featured_listings    => featured_listings.collect { |bl| bl.short_version },
                 :coupons_available    => !territory.coupons.active.empty?,
                 :slug_name            => territory.slug.name,
                 :ga_tracker           => santize_google_analytics( territory.tracking_code )[:code],
                 :mobile_contact_us    => territory.mobile_contact_us
               }

    respond_with response
  end
end
