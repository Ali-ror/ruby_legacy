# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spork'
require 'fileutils'

Spork.prefork do
  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'remarkable/active_record'
  require 'faker'
  require 'email_spec'
  
  include ActionDispatch::TestProcess

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"
    
    config.include Devise::TestHelpers, :type => :controller
    
    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    config.after( :each ) do
      FileUtils.rm_rf File.join( Rails.root, "public", "testuploads" )
    end
    
    config.include Devise::TestHelpers, :type => :controller
    config.include EmailSpec::Helpers
    config.include EmailSpec::Matchers
  end
  
  # Helper for current email address
  module EmailHelpers
    def current_email_address
      # Replace with your a way to find your current email. e.g @current_user.email
      # last_email_address will return the last email address used by email spec to find an email.
      # Note that last_email_address will be reset after each Scenario.
      @email || (@user.nil? ? nil : @user.email) || last_email_address || "example@example.com"
    end
  end
  
  include EmailHelpers
end

Spork.each_run do
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
end