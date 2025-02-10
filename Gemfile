source "https://rubygems.org"

ruby "3.4.1"

gem "bcrypt", "~> 3.1"
gem "bootsnap", require: false
gem "countries", require: "countries/global"
gem "csv"
gem "honeybadger", "~> 5.3"
gem "icalendar"
gem "image_processing"
gem "importmap-rails"
gem "litestack", github: "oldmoe/litestack"
gem "matrix", "~> 0.4.2"
gem "prawn", "~> 2.4"
gem "puma", ">= 5.0"
gem "rails", "~> 8"
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
  gem "hamal"
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
