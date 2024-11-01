module NavigationHelpers
  def homepage
    "/"
  end
  
  # Administration

  def admin_homepage
    "/admin"
  end
  
  def edit_administrator_path(obj)
    id = obj.respond_to?("to_i") ? obj : obj.id
    "/admin/administrators/#{id}/edit"
  end

  # Territory  
  def territory_page( territory )
    "/admin/territories/#{territory.id}"
  end

  # Territory > Headers

  def headers_page( territory )
    "/admin/territories/#{territory.id}/headers"
  end

  # Territory > Banners

  def banners_page( territory )
    "/admin/territories/#{territory.id}/banners"
  end

  # Territory > Business Listings

  def business_listings_page( territory )
    "/admin/territories/#{territory.id}/business_listings"
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance