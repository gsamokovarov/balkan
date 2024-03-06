module Settings
  extend self

  def admin_name = get :admin_name
  def admin_password = get :admin_password

  def sendgrid_api_key = get :sendgrid_api_key

  def stripe_secret_key = get :stripe_secret_key
  def stripe_webhook_secret = get :stripe_webhook_secret

  private

  def get(name)
    Rails.configuration.credentials.fetch name, ENV.fetch(name.to_s.upcase)
  end
end
