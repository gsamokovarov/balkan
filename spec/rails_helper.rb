ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rspec/rails"
require "rspec/xunit"

require "spec_helper"

abort "Cannot run tests in production mode" if Rails.env.production?

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new app, browser: :chrome, args: ["headless"]
end

Capybara.javascript_driver = :selenium_chrome

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include SpecSupport::StripeHelper

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
