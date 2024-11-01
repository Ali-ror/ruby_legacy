class Admin::BusinessListingsController < Admin::AdministrationController
  include ActionView::Helpers::NumberHelper
  before_filter :collection, :only => [:index]

  load_and_authorize_resource
  respond_to :html, :json, :js

  def index
    index! do |format|
      format.json do
        listings = @territory.business_listings.paid_active
        listings = @territory.business_listings.active if params[:all_listings]
        listings = listings.has_owner_bios if params[:owner]
        render :text => listings.search_by( params[:keyword] ).to_json( :only => ["name", "id"] )
      end
      format.csv  { csv_dump }
    end
  end

  def new
    new! do |format|
      @business_listing.build_address
      @business_listing.links.build
      @business_listing.business_listing_categories.build
    end
  end

  def create
    create! do |success, failure|
      @business_listing.build_address unless @business_listing.address
      success.html { redirect_to admin_territory_business_listings_path( @business_listing.territory, :specifically => @business_listing.id ) }
    end
  end

  def edit
    edit! do |format|
      @business_listing.build_address unless @business_listing.address
      @business_listing.business_listing_categories.build unless @business_listing.business_listing_categories
    end
  end

  def update
    reject_unauthorized_params
    update! do |success, failure|
      success.html do
        if current_user.is_global_admin? || current_user.is_territory_admin_for?( @business_listing.territory )
          path = admin_territory_business_listings_path( @business_listing.territory, :specifically => @business_listing.id )
        else
          # If the business listing belongs to user redirect the user to their listings page
          path = admin_business_listings_path( :specifically => @business_listing.id )
        end
        redirect_to path
      end
    end
  end

  def publish
    @obj = BusinessListing.find params[:id]
    @obj.publish!

    respond_to do |format|
      format.js   { render :template => "admin/business_listings/publish" }
    end
  end

  def unpublish
    @obj = BusinessListing.find params[:id]
    @obj.unpublish!

    respond_to do |format|
      format.js   { render :template => "admin/business_listings/publish" }
    end
  end

  protected

  def collection
    if @territory.blank?
      @business_listings = current_user.business_listings.includes [ :pictures, :comments, :coupons, :rewards, :file_models, :slug, :user ]
    else
      @business_listings = @territory.business_listings.includes [ :pictures, :comments, :coupons, :rewards, :file_models, :slug, :user ]
    end

    if params[:filter2]
      if !params[:filter3].nil?
        @business_listings = @business_listings.send( params[:filter2].to_sym ).send( params[:filter3].to_sym )
      else
        @business_listings = @business_listings.send( params[:filter2].to_sym )
      end
    elsif params[:filter4]
      category = Category.find( params[:filter4] )
      @business_listings = category.business_listings.where( :territory_id => @territory.id )
    end

    if params[:filter]
      t = BusinessListing.arel_table

      if params[:filter] == "0-9"
        matches = (0..9).collect{ |i| "#{i.to_s}%" }
        @business_listings = @business_listings.where( t[:name].matches_any( matches ) )
      else
        @business_listings = @business_listings.where( t[:name].matches( "#{params[:filter]}%" ) )
      end
    end

    if params[:keyword]
      @business_listings = @business_listings.search_by( params[:keyword] )
    end

    if params[:published]
      if params[:published] == "true"
        @business_listings = @business_listings.where( :published => true )
      else
        @business_listings = @business_listings.where( "business_listings.published = false OR business_listings.published IS NULL" )
      end
    end

    if params[:specifically]
      @business_listings = @business_listings.where( :id => params[:specifically] )
    end

    if !current_user.is_admin?
      @business_listings = @business_listings.select { |bl| can? :read, bl }
    end

    @business_listings = @business_listings.paginate( :page => params[:page], :per_page => params[:limit] || RESULT_LIMT )
  end

  # csv dump
  def csv_dump
    data = CSV.generate do |csv|
      csv << [
        "First Name",
        "Last Name",
        "Email",
        "Business Name",
        "Member Type",
        "Address 1",
        "Address 2",
        "City",
        "State",
        "Zip",
        "Phone",
        "Fax",
        "Expires",
        "Created At"
      ]

      @territory.business_listings.each do |listing|
        csv << [
          listing.user.first_name,
          listing.user.last_name,
          listing.user.email,
          listing.name,
          listing.package_type,
          listing.address.address1,
          listing.address.address2,
          listing.address.city,
          listing.address.state,
          listing.address.zip,
          number_to_phone(listing.phone),
          number_to_phone(listing.fax),
          listing.expires,
          listing.created_at
        ] if listing.user
      end
    end

    send_data data,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=listing-members-#{Time.now.strftime("%d-%m-%Y")}.csv"
  end

  # This could be cleaned up
  def reject_unauthorized_params
    if @business_listing && @business_listing.belongs_to?(current_user) && !current_user.is_territory_admin_for?(@business_listing.territory)
      ["user_id", "package_type", "business_tier" ,"expires"].each { |p| params["business_listing"].delete(p) }
    end
  end
end
