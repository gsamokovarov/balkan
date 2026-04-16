ENV["RAILS_ENV"] ||= "test"

ENV["H_CAPTCHA_SECRET"] = nil
ENV["H_CAPTCHA_SITE_KEY"] = nil

ENV["APPLE_WALLET_TEAM_IDENTIFIER"] = "TESTTEAM01"
ENV["APPLE_WALLET_PASS_TYPE_IDENTIFIER"] = "pass.com.example.test"
ENV["APPLE_WALLET_CERTIFICATE"] = <<~PEM
  -----BEGIN CERTIFICATE-----
  MIIClDCCAXwCAQEwDQYJKoZIhvcNAQELBQAwDzENMAsGA1UEAwwEVGVzdDAgFw0y
  NDEyMzEyMjAwMDBaGA8yMDk4MTIzMTIyMDAwMFowDzENMAsGA1UEAwwEVGVzdDCC
  ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMcyB1Ii5EBUgZeWR3FLjYGa
  4CS9Df1BI//7hF2jR015WfuOTBNy0B+RF+MWWOIhHgNktPD7Tao3LZ2ewbRtvamO
  4P9o+wkEOMigiiFfQ7cHRI5JQigrf4Eikd+JU1sSwm0Q3ABDLUINp8t3VQdtn4j1
  jHpZi270S1uIqyztBwSSOPdIsBa2UA4GJo/YfLVVTxKKyQ15//KqycN1DRxCvOdj
  hPX5nQpsNGw7v5Thc6V+F+K4lAYYlJiy1yZY8/7bki/q9cdOEqPUbLkYy1yGgZu8
  QV92iBqWkLNjGH8NmWVqhnLvZZbejribxCmMfyRWZcTAZVHVcjppW6r+wIa/vFMC
  AwEAATANBgkqhkiG9w0BAQsFAAOCAQEABHaD+mA9Z6oarSlOk2JzBxKE54gcD/t0
  o+59GGAley1InXm+MbrhQ1mxsQ3bI9P1bAzODoyskt6uuuBGa2eNe2cgj0ODvRsN
  lD27SlK2gkhoWgbaNt6FgjpAm+CxtXloARDkiIpx1PjKNgqsjIBoRGwyFsyNF/Oi
  9e7G/rSAMC9gO1h0KBwgezJ+++MdNBLksoKsheI8KYHJSO5nynFTp3AY6pEmaIdg
  hKxOokoVtAcDd5txhmpTdzE4b3jZ335S/JRFGpAao+rwxKo78PuCf5S4EQi0bs8t
  DGOXqN8+R9Y5kUwJgBFHqC1iF2TMX/ZVDX5QB41NStyjDQXis4Wx4g==
  -----END CERTIFICATE-----
PEM
ENV["APPLE_WALLET_KEY"] = <<~PEM
  -----BEGIN RSA PRIVATE KEY-----
  MIIEpAIBAAKCAQEAxzIHUiLkQFSBl5ZHcUuNgZrgJL0N/UEj//uEXaNHTXlZ+45M
  E3LQH5EX4xZY4iEeA2S08PtNqjctnZ7BtG29qY7g/2j7CQQ4yKCKIV9DtwdEjklC
  KCt/gSKR34lTWxLCbRDcAEMtQg2ny3dVB22fiPWMelmLbvRLW4irLO0HBJI490iw
  FrZQDgYmj9h8tVVPEorJDXn/8qrJw3UNHEK852OE9fmdCmw0bDu/lOFzpX4X4riU
  BhiUmLLXJljz/tuSL+r1x04So9RsuRjLXIaBm7xBX3aIGpaQs2MYfw2ZZWqGcu9l
  lt6OuJvEKYx/JFZlxMBlUdVyOmlbqv7Ahr+8UwIDAQABAoIBADQtj6tdRmrvd+7M
  R7SOtOeBOTuGZjazrIluSfL5RUEvC3oQgS8LASdzq00p2miJgkIjTB5fxa1TvNgv
  8M+he3AB5EAjMLbg6zrqiqRJPwSfm76lw/Wfx0t9Uba7UyFlHZbSNr6+2gkWaKCs
  hpJmjcajg4O9FwAeb+rvNt+SyybP6/UwMalvaDGx/Xw+6jjfngMVjRm+O8URmiXq
  Y9RFCfgZ71SNA3hRwQKMEoDeSiIWC0HlEhPZJUactCUuOBy1KsInnZdPGC0cHfZD
  MigRQesK1rUZmLM299wdMCuTWojntm6m+5JdyVapdbSBFrh/GnQxNMSzEDY6Gm9f
  IXAkgBECgYEA9TTGuq2fQSAdPF4S98kJZx1nIWuWmGKKgRLXTszAPdZGKcv/OGWz
  J2lW/jPwoa8pw0/IOviU1o7dUkMWVTEOmBsD1lPSe2i4F+RowA0hLz56dFHtHkV4
  zbDcgFWatHnuc+tQuoBFiFQ9vKS6D78XiwMsCqMLOWwvwwU9mJQMvUsCgYEAz/bC
  GUuMNxJh9J1X2NKt9NTUrSVCzlWTIq+BMKnV8TQo+zX2ZXVq58F8owDN0iaF/4t2
  f+aPboeLmi8saVgjYwt1LngM9r3Idp3SpkKf6ZnGYBbh3Iaq3HL2ymAQmvsMqEYi
  MRXU9kexoyjNFAioULVTntGRaECVPNM+XOH7wBkCgYEAwCEdQfJ+4VGfdsijhiGw
  y2n/f/FEK5yyt9YifGz0iL9XdLKSBQey68OfVUkvWBDe4VmnI4XZYZDJnAZS/meU
  7tvkEtDVELuJ27at2SWwhcsnufLjn5+Bu3HEJI5uzNDpZUzRkYCmet6/DQvpeiMZ
  +GOA48jDJ7g8aEu36tC+dqcCgYEAsmYgA8sHMYcXeNwxK9MvX0PkXdQFBzPp0Gt2
  C+TlntD8BuQ3xrl/R+h3nu1los1hTeK5eOa0TEECxPWKx6PQV3rQv1hE5rXPbdHd
  jrrAq4g64NtATglIMWx9wQW/uPN73C6tziXIVq0R+cFai8ERgorKfQeSETi1zUP5
  z3wclqECgYBXs178YA4Z/fCCUeKk4m081fVQWa9oco1ObuZiMufDYSAVL9e+H4xh
  mxNY1imFR8+ux2FqNX7CwBGEPeaOiif2Z+p4B2nW5dmTb11SW9WAW4J1mm4deXoL
  vhluR2h88ZTwMW/IFTXExJzR2Doi7bE4aW0hFR063tgJU6vp48TWJQ==
  -----END RSA PRIVATE KEY-----
PEM
ENV["APPLE_WALLET_WWDR"] = ENV["APPLE_WALLET_CERTIFICATE"]

require_relative "../config/environment"
require "rspec/rails"
require "rspec/xunit"
require "spec_helper"

Dir[Rails.root.join("spec/support/**/*.rb")].each { require it }

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
Capybara.default_max_wait_time = 5 # seconds
Capybara.server = :puma, { Silent: true }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Support::StripeHelper
  config.include Support::PDFAssertions
  config.include Support::AuthenticationHelper, type: :request

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
