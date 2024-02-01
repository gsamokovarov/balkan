class ChangeOrderStripeCheckoutSessionDefault < ActiveRecord::Migration[7.1]
  def change
    change_column_null :orders, :stripe_checkout_session, true
    change_column_default :orders, :stripe_checkout_session, from: "{}", to: nil
  end
end
