module Settings
  extend self

  def stripe_secret_key = get __method__
  def stripe_webhook_secret = get __method__

  def sendgrid_api_key = get __method__

  def h_captcha_secret = get __method__
  def h_captcha_site_key = get __method__

  def google_api_key = get __method__

  def apple_wallet_team_identifier = get __method__
  def apple_wallet_pass_type_identifier = get __method__
  def apple_wallet_certificate_path = get __method__
  def apple_wallet_key_path = get __method__
  def apple_wallet_key_password = get __method__, optional: true
  def apple_wallet_wwdr_path = get __method__

  def development_event = get __method__, optional: true

  private

  class MissingError < StandardError
    def initialize(name) = super("Credential #{name} or environment variable #{name.to_s.upcase} is missing")
  end

  def get(name, optional: Rails.env.local?)
    ENV.fetch name.to_s.upcase do
      Rails.application.credentials.fetch name do
        raise MissingError, name unless optional || ENV["SETTINGS_FORCE_OPTIONAL"] == "1"
      end
    end
  end
end
