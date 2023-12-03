source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.1"
gem "sprockets-rails"
gem "pg"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "tailwindcss-rails", "~> 2.0"
gem "frozen_record", "~> 0.27.0"
gem "rqrcode", "~> 2.0"
gem "stripe"
gem "early", "~> 0.3.1"
gem "honeybadger", "~> 5.3"
gem "icalendar"

group :development do
  gem "web-console"
  gem 'rspec-rails', '~> 6.1.0'
  gem 'rspec-xunit'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "hashie"
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'factory_bot_rails'
end
