class Admin::CommentsController < Admin::AdministrationController 
  before_filter :load_business_listing
  before_filter :collection, :only => [:index]
    
  load_and_authorize_resource

  def create    
    create! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_comments_path( @territory, @business_listing ) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_comments_path( @territory, @business_listing ) }
    end
  end
  
  def destroy
    destroy! do |success, failure|
      success.html { redirect_to admin_territory_business_listing_comments_path( @territory, @business_listing ) }
    end
  end

  protected
  
  def build_resource
    @comment ||= @business_listing.comments.new(params[:comment])
  end
    
  def resource
    @comment = @business_listing ? @business_listing.comments.find(params[:id]) : @territory.comments.find(params[:id])
  end
    
  def collection
    @comments = @business_listing ? @business_listing.comments : @territory.comments
    @comments = @comments.send( params[:filter] ) if params[:filter]
    @comments = @comments.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end
end