module UrlHelper
  # Added this method to help with inconsistant link formatting
  def normalize_link(link)
    link = "http://#{link}" unless link.include?("http://")
    return link
  end
  
  # Devise not using the url_options set in config so added this method to override
  def set_mailer_url_options
    ActionMailer::Base.default_url_options = RelyLocal::Application.config.action_mailer.default_url_options
  end
end