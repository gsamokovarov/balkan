module Settings
  extend self

  def admin_name = get __method__
  def admin_password = get __method__

  def sendgrid_api_key = get __method__

  def stripe_secret_key = get __method__
  def stripe_webhook_secret = get __method__

  def h_captcha_secret = get __method__, nil
  def h_captcha_site_key = get __method__, nil

  def google_api_key = get __method__, nil

  def development_event = get __method__, "Balkan Ruby 2025"

  private

  class MissingError < StandardError
    def initialize(name) = super("Credential #{name} or environment variable #{name.to_s.upcase} is missing")
  end

  REQUIRED = Object.new

  def get(name, default = REQUIRED)
    ENV.fetch name.to_s.upcase do
      Rails.application.credentials.fetch name do
        return default unless default == REQUIRED
        return if ENV["SETTINGS_OPTIONAL"] == "1"

        raise MissingError, name
      end
    end
  end
end
