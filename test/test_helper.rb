ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/skip_dsl"
require "minitest/reporters"  # for Colorized output

#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
  
  def setup
    OmniAuth.config.test_mode = true
  end
  
  def mock_auth_hash(user)
    return {
    provider: user.provider,
    uid: user.uid,
    info: {
    email: user.email,
    nickname: user.username
    }
  }
  end
  
  def perform_login(user = nil)
    user ||= User.first
    
    # Tell OmniAuth to use this user's info when it sees
    # an auth callback from github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    
    # Send a login request for that user
    # Note that we're using the named path for the callback, as defined
    # in the `as:` clause in `config/routes.rb`
    get auth_callback_path(:github)
    
    return user
  end
end