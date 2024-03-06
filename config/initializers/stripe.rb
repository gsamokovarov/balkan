Rails.configuration.to_prepare do
  Stripe.api_key = Settings.stripe_secret_key
end
