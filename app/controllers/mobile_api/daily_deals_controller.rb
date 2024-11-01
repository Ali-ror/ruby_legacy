class MobileApi::DailyDealsController < MobileApi::BaseController

  before_filter :set_territory

  def index
    respond_with @territory.daily_deals.for_day( Date.today ).first
  end

  def toggle_subscription
    ut = @current_user.user_territories.for_territory( @territory ).first
    if ut.subscribe_daily_deal_email.nil? || !ut.subscribe_daily_deal_email
      ut.subscribe_daily_deal_email = true
    else
      ut.subscribe_daily_deal_email = false
    end

    ut.save( :validate => false )
    render :json => { :subscribed => ut.subscribe_daily_deal_email }
  end

end
