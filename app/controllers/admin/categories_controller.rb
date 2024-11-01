class Admin::CategoriesController < Admin::AdministrationController  
  before_filter :load_territory
  before_filter :require_territory  
  before_filter :load_category_collections, :except => [:create, :update, :destroy]
  
  cache_sweeper :category_sweeper
  
  load_and_authorize_resource
    
  def new
    @category = Category.new
    new!
  end
    
  def create
    @category = Category.new(params[:category])
    @category.territory = @territory if @territory
    
    create! do |success, failure|
      success.html { redirect_to polymorphic_path([:admin, @territory, Category])}
      failure.html { render :action => "new" }
    end
  end
  
  def update    
    update! do |success, failure|
      success.html { redirect_to polymorphic_path([:admin, @territory, Category])}
      failure.html { render :action => "edit" }
    end
  end

  def hide
    authorize! :hide, @category
    @category.hide( @territory )
    render :text => "Success!", :status => 200
  end

  protected

  def resource
    @category = Category.find( params[:id] )
  end

  private
  
  def load_territory
    @territory = Territory.find(params[:territory_id]) if params[:territory_id]
  end

  def load_category_collections
    if @territory
      cats = Category.roots_and_territory_categories( @territory )
    else
      cats = Category.scoped
    end

    if params[:filter]
      t = Category.arel_table
      cats = cats.where( t[:name].matches( "#{params[:filter]}%" ) )
    end
    
    cats = cats.order( "path_name_cache ASC" ).includes( :business_listings )
    @categories = cats.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end

end