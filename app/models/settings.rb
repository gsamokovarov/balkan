module Settings
  extend self

  def admin_name = get :admin_name
  def admin_password = get :admin_password

  def sendgrid_api_key = get :sendgrid_api_key

  def stripe_secret_key = get :stripe_secret_key
  def stripe_webhook_secret = get :stripe_webhook_secret

  private

  class MissingError < StandardError
    def initialize(name) = super("Credential #{name} or environment variable #{name.to_s.upcase} is missing")
  end

  def get(name)
    ENV.fetch name.to_s.upcase do
      return "" if Rails.env == "development"

      Rails.application.credentials.fetch(name) { raise MissingError, name }
    end
  end
end
