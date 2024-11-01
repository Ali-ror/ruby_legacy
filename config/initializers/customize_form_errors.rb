ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  msg = instance_tag.error_message 
  msg = msg.last if msg.class == Array # get first if multiple error messages (.size only returns length, not dealing w/ an errors object)
  html_tag =~ /type=\"(checkbox|hidden)\"/ ? html_tag : "<span class=\"field_with_errors\">#{html_tag}<span class=\"hint\">&nbsp;#{msg}<\/span></span>".html_safe
  # html_tag =~ /type=\"(checkbox|hidden)\"/ ? html_tag : "#{html_tag}\n<small class=\"message\">#{msg}<\/small>" # check_boxes have double input fields
end