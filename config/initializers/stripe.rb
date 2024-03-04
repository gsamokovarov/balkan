Rails.configuration.after_initialize do
  Stripe.api_key = Settings.stripe_secret_key
end
