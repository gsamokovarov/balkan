Rails.configuration.after_initialize do
  next unless Rails.env.production?

  Rails.configuration.action_mailer.perform_caching = false

  Rails.configuration.action_mailer.delivery_method = :smtp
  Rails.configuration.action_mailer.smtp_settings = {
    user_name: "apikey",
    password: Settings.sendgrid_api_key,
    domain: "balkanruby.com",
    address: "smtp.sendgrid.net",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }

  Rails.configuration.action_mailer.default_url_options = { host: "balkanruby.com" }
  Rails.configuration.action_mailer.asset_host = "https://balkanruby.com"
end
