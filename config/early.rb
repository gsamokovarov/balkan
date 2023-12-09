require "early"

Early do
  require :STRIPE_SECRET_KEY, :STRIPE_WEBHOOK_SECRET
  require :SENDGRID_API_KEY

  default :ADMIN_NAME, "admin"
  default :ADMIN_PASSWORD, "admin"
end
