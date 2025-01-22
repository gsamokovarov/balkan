require "rails_helper"

RSpec.case Webhooks::StripesController, type: :request do
  test "order tickets are not created on checkout.session.expired" do
    stripe_expired_payload =
      {
        id: "evt_1OIEvACUZRkPCoUiKJ2Sfrjz",
        object: "event",
        api_version: "2023-10-16",
        created: 1_701_368_708,
        data: {
          object: {
            id: "cs_live_b1J7Lp95fhgFBMI1pjvhyKsuZ1eR0JK51QNkS1m5WK31NPGAqJ1RVI96pD",
            object: "checkout.session",
            after_expiration: nil,
            allow_promotion_codes: nil,
            amount_subtotal: 40_500,
            amount_total: 40_500,
            automatic_tax: { enabled: false, status: nil },
            billing_address_collection: "required",
            cancel_url: "https://balkanruby.com/",
            client_reference_id: nil,
            client_secret: nil,
            consent: nil,
            consent_collection: nil,
            created: 1_701_282_307,
            currency: "eur",
            currency_conversion: nil,
            custom_fields: [],
            custom_text: { shipping_address: nil, submit: nil, terms_of_service_acceptance: nil },
            customer: nil,
            customer_creation: "if_required",
            customer_details: nil,
            customer_email: nil,
            expires_at: 1_701_368_707,
            invoice: nil,
            invoice_creation: {
              enabled: false,
              invoice_data: { account_tax_ids: nil, custom_fields: nil, description: nil, footer: nil, metadata: {}, rendering_options: nil },
            },
            livemode: true,
            locale: nil,
            metadata: {},
            mode: "payment",
            payment_intent: nil,
            payment_link: nil,
            payment_method_collection: "if_required",
            payment_method_configuration_details: { id: "pmc_1OBvi4CUZRkPCoUiEQXmcDxW", parent: nil },
            payment_method_options: {},
            payment_method_types: %w[card bancontact eps giropay ideal link],
            payment_status: "unpaid",
            phone_number_collection: { enabled: false },
            recovered_from: nil,
            setup_intent: nil,
            shipping_address_collection: nil,
            shipping_cost: nil,
            shipping_details: nil,
            shipping_options: [],
            status: "expired",
            submit_type: nil,
            subscription: nil,
            success_url: "https://balkanruby.com/thanks",
            tax_id_collection: { enabled: true },
            total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
            ui_mode: "hosted",
            url: nil,
          },
        },
        livemode: true,
        pending_webhooks: 1,
        request: { id: nil, idempotency_key: nil },
        type: "checkout.session.expired",
      }
    stripe_checkout_session_uid = stripe_expired_payload.dig :data, :object, :id
    ticket_type = create :ticket_type, :enabled
    pending_tickets = (1..3).map do
      build_ticket_params index: _1, price: 150, ticket_type:
    end

    order = create(:order, stripe_checkout_session_uid:, pending_tickets:)

    stripe_post stripe_expired_payload

    assert_have_http_status response, :ok
    assert_eq order.reload.expired_at?, true
    assert_empty? order.tickets
  end

  test "finalizes order and sends ticket emails on checkout.session.completed" do
    stripe_completed_payload =
      {
        id: "evt_1OI4uGCUZRkPCoUiF9Uko7Ej",
        object: "event",
        api_version: "2023-10-16",
        created: 1_701_330_212,
        data: {
          object: {
            id: "cs_live_b1vG5TnjWZhaqiTUzaMFNi5RFt6jrfnnwCIhenCJXBfJKsbxPEbN19o8Uk",
            object: "checkout.session",
            after_expiration: nil,
            allow_promotion_codes: nil,
            amount_subtotal: 40_500,
            amount_total: 40_500,
            automatic_tax: { enabled: false, status: nil },
            billing_address_collection: "required",
            cancel_url: "https://balkanruby.com/",
            client_reference_id: nil,
            client_secret: nil,
            consent: nil,
            consent_collection: nil,
            created: 1_701_329_761,
            currency: "eur",
            currency_conversion: nil,
            custom_fields: [],
            custom_text: { shipping_address: nil, submit: nil, terms_of_service_acceptance: nil },
            customer: nil,
            customer_creation: "if_required",
            customer_details: {
              address: { city: "Sofia", country: "BG", line1: "...", line2: nil, postal_code: "1000", state: nil },
              email: "deni@example.com",
              name: "Tutuf Ltd",
              phone: nil,
              tax_exempt: "none",
              tax_ids: [type: "eu_vat", value: "..."],
            },
            customer_email: nil,
            expires_at: 1_701_416_161,
            invoice: nil,
            invoice_creation: {
              enabled: false,
              invoice_data: { account_tax_ids: nil, custom_fields: nil, description: nil, footer: nil, metadata: {}, rendering_options: nil },
            },
            livemode: true,
            locale: nil,
            metadata: {},
            mode: "payment",
            payment_intent: "pi_3OI4psCUZRkPCoUi0U7QK32L",
            payment_link: nil,
            payment_method_collection: "if_required",
            payment_method_configuration_details: { id: "pmc_1OBvi4CUZRkPCoUiEQXmcDxW", parent: nil },
            payment_method_options: {},
            payment_method_types: %w[card bancontact eps giropay ideal link],
            payment_status: "paid",
            phone_number_collection: { enabled: false },
            recovered_from: nil,
            setup_intent: nil,
            shipping_address_collection: nil,
            shipping_cost: nil,
            shipping_details: nil,
            shipping_options: [],
            status: "complete",
            submit_type: nil,
            subscription: nil,
            success_url: "https://balkanruby.com/thanks",
            tax_id_collection: { enabled: true },
            total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
            ui_mode: "hosted",
            url: nil,
          },
        },
        livemode: true,
        pending_webhooks: 1,
        request: { id: nil, idempotency_key: nil },
        type: "checkout.session.completed",
      }

    stripe_checkout_session_uid = stripe_completed_payload.dig :data, :object, :id
    ticket_type = create :ticket_type, :enabled
    pending_tickets = (1..3).map do
      build_ticket_params index: _1, price: 150, ticket_type:
    end

    order = create(:order, stripe_checkout_session_uid:, pending_tickets:)

    perform_enqueued_jobs do
      stripe_post stripe_completed_payload
    end

    assert_have_http_status response, :ok
    assert_eq order.reload.completed_at?, true
    assert_eq order.tickets.count, 3

    ticket1, ticket2, ticket3 = order.tickets

    assert_eq ActionMailer::Base.deliveries.count, 4
    email1, email2, email3, email4 = ActionMailer::Base.deliveries

    assert_eq email1.to, [ticket1.email]
    assert_eq email1.subject, "Welcome to Balkan Ruby 2024"

    assert_eq email2.to, [ticket2.email]
    assert_eq email2.subject, "Welcome to Balkan Ruby 2024"

    assert_eq email3.to, [ticket3.email]
    assert_eq email3.subject, "Welcome to Balkan Ruby 2024"

    assert_eq email4.to, ["genadi@hey.com"]
    assert_eq email4.subject, "Balkan Ruby 2024 sale for €405.00"
  end

  test "finalizes order with promo code on checkout.session.completed" do
    stripe_completed_payload =
      {
        id: "evt_1OI4uGCUZRkPCoUiF9Uko7Ej",
        object: "event",
        api_version: "2023-10-16",
        created: 1_701_330_212,
        data: {
          object: {
            id: "cs_test_b14LXJrpxq5nATRjVFsAgnINrXd0CU6pM4sZyqSSplv8F42xIaIQHrHhgc",
            object: "checkout.session",
            after_expiration: nil,
            allow_promotion_codes: true,
            amount_subtotal: 30_000,
            amount_total: 25_500,
            automatic_tax: { enabled: false, status: nil },
            billing_address_collection: "required",
            cancel_url: "http://localhost:3000/",
            client_reference_id: nil,
            client_secret: "[FILTERED]",
            consent: nil,
            consent_collection: nil,
            created: 1_701_534_163,
            currency: "eur",
            currency_conversion: nil,
            custom_fields: [],
            custom_text: { shipping_address: nil, submit: nil, terms_of_service_acceptance: nil },
            customer: nil,
            customer_creation: "if_required",
            customer_details: {
              address: {
                city: "Sofia",
                country: "BG",
                line1: "Line 1",
                line2: nil,
                postal_code: "1000",
                state: nil,
              },
              email: "svetlozar.mihaylov@raketadesign.com",
              name: "SVETLOZAR MIHAYLOV",
              phone: nil,
              tax_exempt: "none",
              tax_ids: [],
            },
            customer_email: nil,
            expires_at: 1_701_620_563,
            invoice: nil,
            invoice_creation: {
              enabled: false,
              invoice_data: {
                account_tax_ids: nil,
                custom_fields: nil,
                description: nil,
                footer: nil,
                metadata: {},
                rendering_options: nil,
              },
            },
            livemode: false,
            locale: nil,
            metadata: {},
            mode: "payment",
            payment_intent: "pi_3OIvyJCUZRkPCoUi1wrnHgvT",
            payment_link: nil,
            payment_method_collection: "if_required",
            payment_method_configuration_details: nil,
            payment_method_options: {},
            payment_method_types: ["card"],
            payment_status: "paid",
            phone_number_collection: { enabled: false },
            recovered_from: nil,
            setup_intent: nil,
            shipping_address_collection: nil,
            shipping_cost: nil,
            shipping_details: nil,
            shipping_options: [],
            status: "complete",
            submit_type: nil,
            subscription: nil,
            success_url: "http://localhost:3000/thanks",
            tax_id_collection: { enabled: true },
            total_details: { amount_discount: 4500, amount_shipping: 0, amount_tax: 0 },
            ui_mode: "hosted",
            url: nil,
          },
        },
        livemode: true,
        pending_webhooks: 1,
        request: { id: nil, idempotency_key: nil },
        type: "checkout.session.completed",
      }

    stripe_checkout_session_uid = stripe_completed_payload.dig :data, :object, :id
    ticket_type = create :ticket_type, :enabled
    pending_tickets = (1..2).map do
      build_ticket_params index: _1, price: 150, ticket_type:
    end

    order = create(:order, stripe_checkout_session_uid:, pending_tickets:)

    stripe_post stripe_completed_payload

    assert_have_http_status response, :ok
    assert_eq order.reload.completed_at?, true
    assert_eq order.tickets.count, 2
    assert_eq order.tickets.first.price, 127.5
    assert_eq order.tickets.last.price, 127.5
  end

  test "sends 404 on non-existent (or deleted) orders" do
    stripe_expired_payload =
      {
        id: "evt_1OIEvACUZRkPCoUiKJ2Sfrjz",
        object: "event",
        api_version: "2023-10-16",
        created: 1_701_368_708,
        data: {
          object: {
            id: "cs_live_b1J7Lp95fhgFBMI1pjvhyKsuZ1eR0JK51QNkS1m5WK31NPGAqJ1RVI96pD",
            object: "checkout.session",
            after_expiration: nil,
            allow_promotion_codes: nil,
            amount_subtotal: 40_500,
            amount_total: 40_500,
            automatic_tax: { enabled: false, status: nil },
            billing_address_collection: "required",
            cancel_url: "https://balkanruby.com/",
            client_reference_id: nil,
            client_secret: nil,
            consent: nil,
            consent_collection: nil,
            created: 1_701_282_307,
            currency: "eur",
            currency_conversion: nil,
            custom_fields: [],
            custom_text: { shipping_address: nil, submit: nil, terms_of_service_acceptance: nil },
            customer: nil,
            customer_creation: "if_required",
            customer_details: nil,
            customer_email: nil,
            expires_at: 1_701_368_707,
            invoice: nil,
            invoice_creation: {
              enabled: false,
              invoice_data: { account_tax_ids: nil, custom_fields: nil, description: nil, footer: nil, metadata: {}, rendering_options: nil },
            },
            livemode: true,
            locale: nil,
            metadata: {},
            mode: "payment",
            payment_intent: nil,
            payment_link: nil,
            payment_method_collection: "if_required",
            payment_method_configuration_details: { id: "pmc_1OBvi4CUZRkPCoUiEQXmcDxW", parent: nil },
            payment_method_options: {},
            payment_method_types: %w[card bancontact eps giropay ideal link],
            payment_status: "unpaid",
            phone_number_collection: { enabled: false },
            recovered_from: nil,
            setup_intent: nil,
            shipping_address_collection: nil,
            shipping_cost: nil,
            shipping_details: nil,
            shipping_options: [],
            status: "expired",
            submit_type: nil,
            subscription: nil,
            success_url: "https://balkanruby.com/thanks",
            tax_id_collection: { enabled: true },
            total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
            ui_mode: "hosted",
            url: nil,
          },
        },
        livemode: true,
        pending_webhooks: 1,
        request: { id: nil, idempotency_key: nil },
        type: "checkout.session.expired",
      }

    create :order, stripe_checkout_session_uid: "test-1234"

    stripe_post stripe_expired_payload

    assert_have_http_status response, :ok
  end

  def build_ticket_params(index:, price:, ticket_type:)
    {
      "name" => "John Doe #{index}",
      "email" => "john-#{index}@example.com",
      "price" => price.to_s,
      "shirt_size" => "L",
      "ticket_type_id" => ticket_type.id,
    }
  end
end
