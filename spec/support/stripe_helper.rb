module SpecSupport
  module StripeHelper
    def stub_stripe_checkout(expected_line_items, session_id:, session_url:)
      stub(Stripe::Checkout::Session).to receive(:create).with(
        stripe_checkout_opts(expected_line_items)
      ).and_return(OpenStruct.new({
        id: session_id,
        url: session_url
      }))
    end

    def stub_stripe_checkout_with_invoice(expected_line_items, session_id:, session_url:)
      stub(Stripe::Checkout::Session).to receive(:create).with(
        stripe_checkout_opts(expected_line_items).merge({
          billing_address_collection: 'required',
          tax_id_collection: {
            enabled: true
          },
        })
      ).and_return(OpenStruct.new({
        id: session_id,
        url: session_url
      }))
    end

    def stripe_checkout_opts(expected_line_items)
      {
        currency: "eur",
        success_url: "http://example.com/thanks",
        cancel_url: "http://example.com/",
        line_items: expected_line_items.map do |line_item|
          {
            price_data: {
              currency: "eur",
              unit_amount: (line_item[:price] * 100).to_i,
              product_data: {
                name: line_item[:description],
              },
            },
            quantity: 1,
          }
        end,
        mode: 'payment',
      }
    end
  end
end
