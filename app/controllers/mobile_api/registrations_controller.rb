class MobileApi::RegistrationsController < MobileApi::BaseController

  def create
    user = User.new :first_name            => params[:first_name],
                    :last_name             => params[:last_name],
                    :email                 => params[:email],
                    :password              => params[:password],
                    :password_confirmation => params[:password_confirmation]

    user.build_address :city => params[:city], :state => params[:state]

    user.address.skip_validations = true

    if user.save
      user.reset_authentication_token!

      render :json => { :success    => true,
                        :auth_token => user.authentication_token,
                        :name       => user.full_name,
                        :email      => user.email }
    else
      render :json => { :success => false,
                        :message => user.errors.full_messages }
    end
  end

end
