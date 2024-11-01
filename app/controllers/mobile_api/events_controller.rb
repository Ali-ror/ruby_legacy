class MobileApi::EventsController < MobileApi::BaseController

  before_filter :set_territory

  def index
    respond_with @territory.events.active.upcoming
  end

end
