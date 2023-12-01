require 'capybara/rspec'
require_relative 'support/stripe_helper'

RSpec.configure do |config|
  config.include SpecSupport::StripeHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
