module SocialLinkHelper
  def social_link(link)
    case link.link_type.name
    when "Twitter"
      content_tag(:li, (link_to "Twitter", link.url, :title => "Twitter", :target => "_blank"), :class => "twitter")
    when "Facebook"
      content_tag(:li, (link_to "Facebook", link.url, :title => "Facebook", :target => "_blank"), :class => "facebook")
    when "LinkedIn"
      content_tag(:li, (link_to "LinkedIn", link.url, :title => "LinkedIn", :target => "_blank"), :class => "linkedin")
    when "Flickr"
      content_tag(:li, (link_to "Flickr", link.url, :title => "Flickr", :target => "_blank"), :class => "flickr")
    when "YouTube"
      content_tag(:li, (link_to "YouTube", link.url, :title => "YouTube", :target => "_blank"), :class => "youtube")
    when "YouTube Channel"
      content_tag(:li, (link_to "YouTube Channel", link.url, :title => "YouTube Channel", :target => "_blank"), :class => "youtube")
    when "Etsy"
      content_tag(:li, (link_to "Etsy", link.url, :title => "Etsy", :target => "_blank"), :class => "etsy")
    when "Blog"
      content_tag(:li, (link_to "Blog", link.url, :title => "Blog", :target => "_blank"), :class => "blogger")
    when "Google+"
      content_tag(:li, (link_to "Google+", link.url, :title => "Google+", :target => "_blank"), :class => "google")
    when "Picasa"
      content_tag(:li, (link_to "Picasa", link.url, :title => "Picasa", :target => "_blank"), :class => "picasa")
    when "Vimeo"
      content_tag(:li, (link_to "Vimeo", link.url, :title => "Vimeo", :target => "_blank"), :class => "vimeo")
    when "Yelp"
      content_tag(:li, (link_to "Yelp", link.url, :title => "Yelp", :target => "_blank"), :class => "yelp")
    when "MySpace"
      content_tag(:li, (link_to "MySpace", link.url, :title => "MySpace", :target => "_blank"), :class => "myspace")
    when "Pinterest"
      content_tag(:li, (link_to "Pinterest", link.url, :title => "Pinterest", :target => "_blank"), :class => "pinterest")
    when "FourSquare"
      content_tag(:li, (link_to "FourSquare", link.url, :title => "FourSquare", :target => "_blank"), :class => "foursquare")
    when "Instagram"
      content_tag(:li, (link_to "Instagram", link.url, :title => "Instagram", :target => "_blank"), :class => "instagram")
    when "UrbanSpoon"
      content_tag(:li, (link_to "UrbanSpoon", link.url, :title => "UrbanSpoon", :target => "_blank"), :class => "urban_spoon")
    when "Tumblr"
      content_tag(:li, (link_to "Tumblr", link.url, :title => "Tumblr", :target => "_blank"), :class => "tumblr")
    else
      return
    end
  end

  def social_icon( link )
    name = link.link_type.name

    return '' if name == "Website"

    name = "YouTube" if name == "YouTube Channel"
    name = "Blogger" if name == "Blog"

    link_to link.url, :title => name, :target => "_blank" do
      image_tag "http://relylocal.com/images/icon_#{name.downcase}.png"
    end

  end

end
