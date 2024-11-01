module Admin::FeaturedHelper

  def add_link( name, type, partial, count, html_options={} )
    output = %Q[<div id="#{type.parameterize}_fields_blueprint" style="display: none" data-count="#{count}">].html_safe
    output << render( :partial => partial )
    output.safe_concat('</div>')

    html_options[:class] = 'add_link'
    html_options["data-association"] = type.parameterize
    output << link_to( name, 'javascript:void(0)', html_options ).html_safe

    output
  end

  def remove_link( name, type )
    link_to(name, "javascript:void(0)", :class => "remove_link", "data-association" => type.parameterize )
  end

end