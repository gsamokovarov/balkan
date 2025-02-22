module SpecSupport
  module StripeHelper
    def stub_stripe_checkout(expected_line_items, session_id:, session_url:, promotion_code: "")
      stub(Stripe::Checkout::Session).to receive(:create)
        .with(stripe_checkout_opts(expected_line_items, promotion_code:))
        .and_return Stripe::Checkout::Session.construct_from(id: session_id, url: session_url)

      stub(Stripe::PromotionCode).to receive(:list)
        .with(code: promotion_code)
        .and_return Stripe::PromotionCode.construct_from(data: [id: promotion_code.presence])
    end

    def stub_stripe_checkout_with_invoice(expected_line_items, session_id:, session_url:, promotion_code: "")
      stub(Stripe::Checkout::Session).to receive(:create)
        .with(stripe_checkout_opts(expected_line_items, promotion_code:,
                                                        billing_address_collection: "required",
                                                        tax_id_collection: { enabled: true }))
        .and_return Stripe::Checkout::Session.construct_from(id: session_id, url: session_url)

      stub(Stripe::PromotionCode).to receive(:list)
        .with(code: promotion_code)
        .and_return Stripe::PromotionCode.construct_from(data: [id: promotion_code.presence])
    end

    def stripe_checkout_opts(expected_line_items, promotion_code: "", **rest)
      {
        currency: "eur",
        success_url: "http://example.com/thanks",
        cancel_url: "http://example.com/",
        line_items: expected_line_items.map do
          {
            price_data: {
              currency: "eur",
              unit_amount: (it[:price] * 100).to_i,
              product_data: {
                name: it[:description],
              },
            },
            quantity: 1,
          }
        end,
        mode: "payment",
        **(promotion_code.present? ? { discounts: [promotion_code:] } : { allow_promotion_codes: true }),
        **rest,
      }
    end

    def stripe_post(payload)
      stub(Stripe::Webhook).to receive(:construct_event)
        .with("", nil, Settings.stripe_webhook_secret)
        .and_return Hashie::Mash.new(payload)

      post "/webhooks/stripe", params: payload.to_s
    end
  end
end
