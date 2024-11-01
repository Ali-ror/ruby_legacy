class Admin::FileModelsController < Admin::AdministrationController
  before_filter :collection, :only => [:index]
  
  belongs_to :business_listing
  
  load_and_authorize_resource
  
  def create
    create! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_file_models_path( @territory, @business_listing ) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_file_models_path( @territory, @business_listing ) }
    end
  end

  protected

  def collection
    @file_models = end_of_association_chain.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end

end