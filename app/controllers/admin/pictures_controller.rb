class Admin::PicturesController < Admin::AdministrationController
  before_filter :load_business_listing
  before_filter :collection, :only => [:index]
    
  load_and_authorize_resource
  
  def create
    create! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_pictures_path( @territory, @business_listing ) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_pictures_path( @territory, @business_listing ) }
    end
  end
  
  def destroy
    destroy! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_pictures_path( @territory, @business_listing ) }
    end
  end

  protected

  def build_resource
    @comment ||= @business_listing.pictures.new(params[:picture])
  end
  
  def resource
    @picture = @business_listing ? @business_listing.pictures.find(params[:id]) : @territory.pictures.find(params[:id])
  end
  
  def collection
    @pictures = @business_listing ? @business_listing.pictures : @territory.pictures
    @pictures = @pictures.send( params[:filter] ) if params[:filter]
    @pictures = @pictures.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end

end