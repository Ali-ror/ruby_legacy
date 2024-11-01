class Admin::EventsController < Admin::AdministrationController
  before_filter :collection, :only => [:index]
  load_and_authorize_resource
  
  def update
    update! do |success, failure|
      success.html { redirect_to admin_territory_events_path( @territory ) }
    end
  end

  protected

  def resource
    @event = @territory.events.find( params[:id] )
  end

  def collection
    @events = @territory.events.admin_pending_or_active_upcoming.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end

end