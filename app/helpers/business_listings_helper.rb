module BusinessListingsHelper
  include ActsAsTaggableOn::TagsHelper

  BUSINESS_TIERS_IMAGES = [ "/images/head_red.png",  # 100% Local
                            "/images/head_blue.png", # Regionally Owned
                            "/images/head_green.png",
                            "/images/head_orange.png",  # Locally Owned Franchise
                            "/images/head_green.png",  # Independent Reseller
                            "/images/bar_graph.png"  # National Sponsor
                           ]
      
  BUSINESS_TIERS_CLASSES = [ "local area",  # 100% Local
                             "regionally-owned area", # Regionally Owned
                             "reseller area",
                             "franchise-text area",  # Locally Owned Franchise
                             "reseller area",  # Independent Reseller
                             "sponsor area"  # National Sponsor
                           ]

  def display_franchise( listing )
    index = BusinessListing::VALID_BUSINESS_TIERS.index( listing.business_tier )
    if index
      value = BusinessListing::VALID_BUSINESS_TIERS[index]
      content_tag :span,
        content_tag( :img, nil, :src => BUSINESS_TIERS_IMAGES[index], :alt => value ),
        :class => "franchise",
        :title => index
    else
    end
  end
  
  def display_franchise_text( listing )
    index = BusinessListing::VALID_BUSINESS_TIERS.index( listing.business_tier )
    if index
      value = BusinessListing::VALID_BUSINESS_TIERS[index]
      content_tag :span, value, :title => value, :class => BUSINESS_TIERS_CLASSES[index]
    else
    end
  end
  
  def tag_links(business_listing)
    territory = business_listing.territory
    content = business_listing.categories.map do |cat|
      link_to(cat.name, territory_category_path(territory, cat.slugger))
    end
        
    if !business_listing.tag_list.empty?
      tags = business_listing.tag_list.collect do |tag|
        link_to(tag, territory_search_path("search[name_or_long_description_or_short_description_contains]" => tag))
      end
      content += tags
    end
    
    content += [link_to(business_listing.name, territory_business_listing_path(territory, business_listing))]
    content += [link_to("Local Businesses in #{territory.name}", territory_root_path(territory))]
    
    content.join(", ").html_safe
  end
end