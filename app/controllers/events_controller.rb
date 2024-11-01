class EventsController < ApplicationController
  before_filter :load_events
  
  def index
    @event  = @territory.events.new
  end
  
  def new
    redirect_to "#{territory_events_path(@territory)}#new_event"
  end
  
  def create
    @event = @territory.events.new(params[:event])
    #@event.user = current_user
    @event.territory = @territory
    
    if @event.save
      flash[:success] = "Your event has been submitted for review!"
      @event = @territory.events.new
    else
      flash[:error] = @event.errors.full_messages.to_sentence
    end
    
    render "index"
  end
  
  private
  
  def load_events
    @events = @territory.events.active.upcoming
    @event_months = @events.group_by { |e| e.when }
  end
end