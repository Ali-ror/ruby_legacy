require 'securerandom'

class Admin::FeaturedListingsController < Admin::AdministrationController
  load_and_authorize_resource :business_listing

  def update
    set_ids = params[:listings][:ids].reject(&:blank?).collect { |id| id.to_i }
    existing_ids = resource.collect(&:id)

    remove = existing_ids - set_ids
    add    = set_ids - existing_ids

    remove.each do |id|
      bl = BusinessListing.find( id )
      bl.featured = false
      bl.save( :validate => false )
    end

    add.each do |id|
      bl = BusinessListing.find( id )
      bl.featured = true
      bl.featured_date = Date.today
      bl.save( :validate => false )
    end

    redirect_to admin_territory_path( @territory )
  end

  protected

  def resource
    @featured_listings = @territory.business_listings.featured
  end

end