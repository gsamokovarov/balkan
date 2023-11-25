require 'rails_helper'

RSpec.case "Buy tickets", type: :feature do
  test "redirects the user to Stripe checkout" do
    stub_stripe_checkout_with_invoice(
      [{
        price: 150,
        description: "Early Bird - John Doe"
      }],
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com/payment"
    )

    visit ticket_path(1)

    expect(page).to have_content 'Buy Early Bird tickets'

    fill_in 'checkout_tickets__name', with: 'John Doe'
    fill_in 'checkout_tickets__email', with: 'john@example.com'
    select 'M', from: 'checkout_tickets__shirt_size'

    check 'checkout_invoice'

    click_button 'Pay'

    expect(page.current_url).to eq("https://stripe-checkout-link.com/payment")
  end
end
