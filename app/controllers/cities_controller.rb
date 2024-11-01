class CitiesController < ApplicationController
  def index
    rewards = params[:rewards] == "true"

    @cities = City.with_territory.includes(:territory).where(:state => params[:state])
    @cities = @cities.joins(:territory).where("territories.rewards_enabled = true") if rewards
    @cities = @cities.sort_by { |c| c.city }.collect { |c| [c.city, c.territory.to_param]}

    respond_to do |format|
      format.html  {}
      format.plain { render :template => "index", :layout => false }
      format.js    { render :text => inline_helper.options_for_select(@cities), :layout => false }
    end
  end
end