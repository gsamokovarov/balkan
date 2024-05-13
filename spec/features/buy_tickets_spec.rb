require "rails_helper"

RSpec.case "Buy tickets", type: :feature do
  test "returns 404 for a disabled ticket type" do
    event = create :event, :balkan2025
    ticket_type = create(:ticket_type, event:)

    visit checkout_path(ticket_type.id)

    assert_eq page.status_code, 404
  end

  test "redirects the user to Stripe checkout" do
    event = create :event, :balkan2025
    ticket_type = create(:ticket_type, :enabled, event:)

    stub_stripe_checkout_with_invoice(
      [price: 100, description: "#{ticket_type.name} - John Doe"],
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com/payment"
    )

    visit checkout_path(ticket_type.id)

    assert_have_content page, "Buy Early Bird tickets"

    fill_in "checkout_tickets__name", with: "John Doe"
    fill_in "checkout_tickets__email", with: "john@example.com"
    select "M", from: "checkout_tickets__shirt_size"

    check "checkout_invoice"

    click_button "Pay"

    assert_eq page.current_url, "https://stripe-checkout-link.com/payment"
  end
end
