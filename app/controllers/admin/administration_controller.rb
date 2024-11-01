class Admin::AdministrationController < ApplicationController
  layout "admin"  
  
  inherit_resources
  belongs_to :territory, :optional => true

  before_filter :authenticate_user!
  check_authorization
  
  respond_to :html
  
  private
    # Override user login authentication
    def authenticate_user!
      super
      unless current_user.is_admin? || current_user.is_listing_manager?
        flash[:error] = "You must login to access this area!"
        redirect_to new_user_session_path
      end
    end
    
    # CanCan seems to have no problem doing authentication except with this case of user
    def validate_administrator
      unless current_user.is_global_admin?
        redirect_to admin_root_path
      end
    end
    
    # Require the loading of a territory if a user is not a global admin
    def require_territory
      redirect_to admin_root_path unless current_user.global_admin? || @territory
    end
end