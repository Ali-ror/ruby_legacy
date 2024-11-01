module RewardsHelper
  def listing_info( listing )
    address = listing.address
    html = "<h2>#{link_to( listing.name, territory_business_listing_url( @territory, listing ) )}</h2>"
    html += "#{address.address1}"
    html += "<br/>" if address.address2.blank?
    html += ", #{address.address2}<br/>" unless address.address2.blank?

    html += "#{address.city}"    unless address.city.blank?
    html += ", #{address.state}" unless address.state.blank?
    html += ", #{address.zip}"   unless address.zip.blank?

    html += "<br/>#{listing.phone}"

    html.html_safe
  end

  def reward_info( reward, index )
    expires = reward.never_expires ? "Never" : reward.expiration_date.strftime('%m/%d/%y')
    "<b>Reward ##{index+1}:</b> #{reward.description} <br/>(Expires: #{expires})".html_safe
  end
end
