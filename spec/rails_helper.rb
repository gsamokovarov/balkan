ENV["RAILS_ENV"] ||= "test"

ENV["H_CAPTCHA_SECRET"] = nil
ENV["H_CAPTCHA_SITE_KEY"] = nil

require_relative "../config/environment"
require "rspec/rails"
require "rspec/xunit"
require "spec_helper"

abort "Cannot run tests in production mode" if Rails.env.production?

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => err
  abort err.to_s.strip
end

Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument "--headless" unless ENV["DEBUG"]
  options.add_argument "--disable-gpu"
  options.add_argument "--disable-extensions"

  Capybara::Selenium::Driver.new app, browser: :chrome, options:
end

Capybara.javascript_driver = :selenium_chrome

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include SpecSupport::StripeHelper

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
