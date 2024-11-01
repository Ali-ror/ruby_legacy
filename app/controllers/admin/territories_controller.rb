class Admin::TerritoriesController < Admin::AdministrationController
  before_filter :collection, :only => [:index]
  before_filter :redirect_admin, :only => [:index]
  load_and_authorize_resource
  
  respond_to :html, :json, :js

  def new
    new! do
      @territory.user_territory_local_admins.build
      @territory.cities.build
    end
  end

  def update
    update! do |success, failure|
      success.html do
        if params[:territory_nav]
          redirect_to admin_territory_path( @territory )
        else
          redirect_to admin_territories_path
        end
      end
    end
  end
  
  def docs_help
  end

  def mass_email
    @mass_email = MassEmail.new
    @mass_email.reply_to = @current_user.email
  end

  def send_mass_email
    @mass_email = MassEmail.new( params[:mass_email] )
    if @mass_email.valid?
      Postoffice.mass_email( @mass_email, @territory ).deliver
      redirect_to admin_territory_path( @territory )
    else
      render :mass_email
    end
  end

  def reset_default_text
    @territory.reset_default_text
    respond_to do |format|
      format.js   { render :js => "alert('Reset default text for #{@territory.name} complete.')" }
    end
  end

  private
  
  def collection
    @territories = current_user.is_global_admin? ? Territory.scoped : current_user.local_admins.scoped
    @territories = @territories.includes( :cities, :local_admins )

    if !params[:keyword].blank? || !params[:starts_with].blank?
      @territories = @territories.search_with(:keyword => params[:keyword], :starts_with => params[:starts_with])
    end

    #@territories = @territories.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
    @territories = @territories.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end

  # Redirect an admin to their territory dashboard if they just have one territory
  def redirect_admin
    unless current_user.is_global_admin?
      territories = current_user.local_admins
      redirect_to admin_territory_path(territories.first) and return false if territories.count == 1 
    end
  end
end
