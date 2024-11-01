class MobileApi::SessionsController < MobileApi::BaseController
  #prepend_before_filter :require_no_authentication, :only => [ :create ]
  #include Devise::Controllers::InternalHelpers

  before_filter :ensure_params_exist

  def create
    #Rails.logger.debug "-------------------------------------create"
    #build_resource
    user = User.find_by_email params[:email]
    Rails.logger.debug user.inspect

    if user && user.valid_password?( params[:password] )
      user.reset_authentication_token!
      render :json => { :success    => true,
                        :auth_token => user.authentication_token,
                        :name       => user.full_name,
                        :email      => user.email,
                        :dotd_subscriptions => user.user_territories.collect { |ut| [ ut.territory_id, ut.subscribe_daily_deal_email  || false ] }}
    else
      invalid_login_attempt
    end
  end

  # GET /resource/sign_out
  #def destroy
    #set_flash_message :notice, :signed_out if signed_in?(resource_name)
  #  sign_out_and_redirect resource_name
  #end

  protected

  def ensure_params_exist
    if params[:email].blank? || params[:password].blank?
      render :json => { :success => false, :message => "missing email or password parameter" }, :status => 422
    end
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json => { :success => false, :message => "Error with your email or password" }, :status => 401
  end

end
