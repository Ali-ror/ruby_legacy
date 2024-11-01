module MediaTabHelper
  def media_tabs
    html = ""
    tab_count = 0

    # nothing is shown for non members except the map
    # [ tab label, method name, show for feeder ]

    [
      [ "meet the leader", "owner_bio",      false ],
      [ "videos",          "you_tube_links", false ],
      [ "photos",          "pictures",       true  ],
      [ "map",             "show_map?",      true  ],
      [ "downloads",       "file_models",    false ]
    ].each do |media|
      if media.length > 1
        if media[1].include?("?")
          do_not_render_tab = !@business_listing.send(media[1])
        else
          do_not_render_tab = @business_listing.send(media[1]).blank?
        end
      else
        do_not_render_tab = @business_listing.send(media[0]).blank?
      end

      if @business_listing.non_member_listing?
        do_not_render_tab = true unless media[0] == 'map'
      elsif @business_listing.feeder_listing?
        do_not_render_tab = !media[2]
      end

      unless do_not_render_tab
        tab_count += 1
        link_options = { "data-ref" => "##{media[0].parameterize("_")}",
                         "data-group" => "media",
                         "data-highlight" => "true",
                         :class => "tab #{media[0]}-link" }
        link_options.merge!("data-default" => "true") if tab_count == 1
        html += content_tag(:li, link_to(media[0].titlecase, "#", link_options))
      end
    end

    unless tab_count == 0
      return content_tag(:ul, html.html_safe, :class => "tabs").html_safe
    end
  end
end
