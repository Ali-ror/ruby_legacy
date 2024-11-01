module ModerationHelper
  def change_status(obj)
    html = "("
    if obj.state == "Pending"
      html += link_to "Approve", polymorphic_url([:accept, :admin, obj.territory, obj]), :class => "remote"
      html += "&nbsp;|&nbsp;"
      html += link_to "Reject", polymorphic_url([:reject, :admin, obj.territory, obj]),  :class => "remote"
    elsif obj.state == "Approved"
      html += link_to "Reject", polymorphic_url([:reject, :admin, obj.territory, obj]),  :class => "remote"
    else
      html += link_to "Approve", polymorphic_url([:accept, :admin, obj.territory, obj]), :class => "remote"
    end
    html += ")"
    return html.html_safe
  end
end