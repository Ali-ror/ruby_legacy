class MobileApi::BaseController < ActionController::Base
  respond_to :json

  before_filter :authenticate_user

  protected

  def set_territory
    @territory = Territory.find params[:territory_id]
  end

  def set_business_listing
    set_territory
    @business_listing = BusinessListing.find params[:business_listing_id]
  end

  private

  def authenticate_user
    if params[:auth_token]
      @current_user = User.find_by_authentication_token( params[:auth_token] )
      #Rails.logger.debug "-------------------------------------authenticate_user"
      #p @current_user
      unless @current_user
        render :json => { :error => "Token is invalid." }
        false
      end
      true
    end
  end

  def current_user
    @current_user
  end

end
