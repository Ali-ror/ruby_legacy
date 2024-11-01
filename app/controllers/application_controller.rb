class ApplicationController < ActionController::Base
  include UrlHelper

  before_filter :set_mailer_url_options
  before_filter :load_territory
  before_filter :load_header

  protect_from_forgery :only => [:create, :update, :destroy]

  helper_method :full_address

  private

  # Store a location in a session
  def store_location
    session[:user_return_to] = request.url
  end

  # Redirect back to a stored location or go to default location
  def redirect_back_or_default(default)
    redirect_to stored_location_for("user") || default
  end

  # Load Territory based on params
  def load_territory
    # TODO: Get a better way of doing this filtering
    reject_list = %w{ admin stylesheets rely_images PIE favicon }
    if params && params[:territory_id] && !reject_list.include?(params[:territory_id])
      @territory =  Territory.find(params[:territory_id])
      store_territory_id @territory.id
      # add territory to current user if they aren't already associated with it
      current_user.territories << @territory if current_user && !current_user.territories.include?(@territory)

      PrivateLabel.instance.setup( @territory )
    else
      PrivateLabel.instance.setup()
    end
  end

  # Load the header for the site
  def load_header
    if @territory
      @current_header = @territory.headers.blank? ? nil : @territory.headers.order("RAND()").limit(1).first.header
    end
  end

  # Load Business Listing based on params
  def load_business_listing
    @business_listing = @territory.business_listings.find(params[:business_listing_id]) if params && params[:business_listing_id]
  end

  # Specifically pass in territory for CanCan Authorizations
  def current_ability
    load_territory
    @current_ability ||= Ability.new(current_user, @territory)
  end

  # This clears out the password requirement for updating a record using devise
  def clean_password(param_set)
    if params[param_set.to_sym][:password].blank?
      [:password,:password_confirmation,:current_password].collect { |p| params[param_set.to_sym].delete(p) }
    end
  end

  # Grab address for an object
  def full_address(object)
    address = object.address
    addr = "#{address.address1}, #{address.address2}"
    addr += "#{address.city}, #{address.state}, #{address.zip}"
    addr
  end

  def inline_helper
    InlineHelper.new
  end

  def get_stored_territory_id
    #Rails.logger.debug "-------------------------------------get_stored_territory_id"
    #Rails.logger.debug "-------------------------------------stored session: #{session[:territory_id].inspect}"
    #Rails.logger.debug "-------------------------------------stored cookies: #{cookies[:territory_id].inspect}"
    if session[:territory_id]
      #Rails.logger.debug "-------------------------------------session"
      #Rails.logger.debug session[:territory_id].inspect
      session[:territory_id]
    elsif cookies[:territory_id]
      #Rails.logger.debug "-------------------------------------cookie"
      #Rails.logger.debug cookies[:territory_id].inspect
      cookies[:territory_id]
    else
      #Rails.logger.debug "-------------------------------------nil"
      nil
    end
  end

  def store_territory_id( territory_id )
    #Rails.logger.debug "-------------------------------------store_territory_id(#{territory_id})"
    cookies[:territory_id] = { :value => territory_id, :expires => 1.year.from_now }
    session[:territory_id] = territory_id
  end

  class InlineHelper
    include ActionView::Helpers::FormOptionsHelper
  end
end
