require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "steak"
require "capybara/rails"
require "database_cleaner"

module Steak::Capybara
  include Rack::Test::Methods
  include Capybara
  
  def app
    ::Rails.application
  end
end

RSpec.configuration.include Steak::Capybara, :type => :acceptance

Rspec.configure do |config|
  config.use_transactional_fixtures = false
  
  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
      Capybara.current_driver = :selenium
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after(:each) do
    if example.metadata[:js]
      Capybara.use_default_driver
    end
    DatabaseCleaner.clean
  end
end

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}