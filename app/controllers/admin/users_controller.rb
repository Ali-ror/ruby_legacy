class Admin::UsersController < Admin::AdministrationController
  before_filter :load_territory
  before_filter :require_territory
  
  before_filter :resource,   :except => [:new, :index, :create]
  before_filter :collection, :only => [:index]
  
  load_and_authorize_resource
  
  respond_to :html, :json, :js
  
  def new
    new! do
      if @territory
        @user.user_territories.build :territory => @territory
      else
        @user.user_territories.build
      end
      @user.build_address
    end
  end
  
  def edit
    edit! do
      @user.user_territories.build if @user.user_territories.blank?
      @user.build_address if @user.address.blank?
    end
  end
  
  def index
    index! do |format|
      format.json { render :text => @users.to_json(:only => ["first_name", "last_name", "email", "id"])  }
    end
  end
  
  def create
    @user = User.new( params[:user] )
    admin_only_filtering
    
    create! do |success, failure|
      success.html { redirect_to polymorphic_path([:admin, @territory, User])}
      failure.html { render :action => "new" }
    end
  end

  def update    
    clean_password(:user)
    admin_only_filtering
    
    update! do |success, failure|
      success.html { redirect_to polymorphic_path([:admin, @territory, User])}
      failure.html { render :action => "edit" }
    end
  end
    
  protected
    
    def resource
      @user = User.find(params[:id]) if params[:id]
    end
    
    def collection
      if current_user.is_global_admin? && @territory.blank?
        @users = User.scoped
      else
        @users = @territory.users
      end
      
      if !params[:keyword].blank? || !params[:starts_with].blank?
        @users = @users.search_with(:keyword => params[:keyword], :starts_with => params[:starts_with])
      end

      t = @territory || nil
      
      # Filtering
      unless request.path.include?("users.json")
        case params[:user_type]
        when "global_admins"
          @users = @users.global_admins
        when "local_admins"
          @users = @users.local_admin_users( t )
        when "listing_managers"
          @users = @users.business_members( t )
        when "generic_users"
          @users = @users.generic_users
        when "all"
          @users = @users
        else
          @users = @users.business_members
        end
      end

      @users = @users.uniq.paginate(:page => params[:page], :per_page => params[:limit] || RESULT_LIMT)
    end
    
    def admin_only_filtering
      # only set global admin if the current user has the ability to
      if current_user.is_global_admin?
        # User is a global admin
        @user.global_admin = params[:user][:global_admin] == "1" ? true : false
        @user.save( :validate => false )
      else
        # Only global user can set territory admins, reject setting if they try and hack view
        params["user"]["user_territories_attributes"].each { |k,v| v.delete("local_admin") }
      end
    end
end
