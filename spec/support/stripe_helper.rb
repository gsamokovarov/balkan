module SpecSupport
  module StripeHelper
    def stub_stripe_checkout(ticket_type, tickets_params, session_id:, session_url:)
      stub(Stripe::Checkout::Session).to receive(:create).with(
        stripe_checkout_opts(ticket_type, tickets_params)
      ).and_return(OpenStruct.new({
        id: session_id,
        url: session_url
      }))
    end

    def stub_stripe_checkout_with_invoice(ticket_type, tickets_params, session_id:, session_url:)
      stub(Stripe::Checkout::Session).to receive(:create).with(
        stripe_checkout_opts(ticket_type, tickets_params).merge({
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

    def stripe_checkout_opts(ticket_type, tickets_params)
      {
        currency: "eur",
        success_url: "http://example.com/thanks",
        cancel_url: "http://example.com/",
        line_items: tickets_params.map do |ticket_params|
          {
            price_data: {
              currency: "eur",
              unit_amount: (ticket_type.price * 100).to_i,
              product_data: {
                name: "#{ticket_type.type} - #{ticket_params[:name]}",
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
