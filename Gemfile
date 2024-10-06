source "https://rubygems.org"

ruby "3.3.3"

gem "bootsnap", require: false
gem "countries", require: "countries/global"
gem "csv"
gem "frozen_record", "~> 0.27.0"
gem "honeybadger", "~> 5.3"
gem "icalendar"
gem "importmap-rails"
gem "invisible_captcha"
gem "jbuilder"
gem "litestack"
gem "matrix", "~> 0.4.2"
gem "prawn", "~> 2.4"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.1"
gem "redcarpet"
gem "rqrcode", "~> 2.0"
gem "sprockets-rails"
gem "sqlite3"
gem "stimulus-rails"
gem "stripe"
gem "tailwindcss-rails", "~> 2.0"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development do
  gem "rspec-rails", "~> 6.1.0"
  gem "rspec-xunit"
  gem "rubocop"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "hashie"
  gem "pdf-inspector", require: "pdf/inspector"
  gem "selenium-webdriver"
end

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails"
end
