class RegistrationsController < Devise::RegistrationsController
  before_filter :store_location, :only => [:edit]

  def new
    @user = User.new
    @user.build_address
  end

  def create
    @user = User.new(params[:user])
    @user.build_address(params[:user][:address_attributes])
    @user.address.skip_validations = true

    if @user.save
      @user.territories << @territory if @territory
      set_flash_message :notice, :signed_up
      sign_in_and_redirect(resource_name, resource)
    else
      clean_up_passwords(resource)
      render_with_scope :new
    end
  end

  def update
    clean_up_passwords(resource)
    @user.address.skip_validations = true
    
    if @user.update_attributes(params[:user])
      flash[:success] = "You successfully updated your information."
      redirect_to edit_registration_path(current_user)
    else
      render "edit"
    end
  end
end