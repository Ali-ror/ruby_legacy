class Admin::BannersController < Admin::AdministrationController
  before_filter :collection, :only => [:index]
  load_and_authorize_resource
  
  def create
    create! do |success, failure|
      success.html { redirect_to admin_territory_banners_path( @territory ) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to admin_territory_banners_path( @territory ) }
    end
  end

  protected

  def collection
    @banners ||= end_of_association_chain.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end

end