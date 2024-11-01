# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RelyLocal::Application.initialize!

ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML)
