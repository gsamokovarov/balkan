module Webhooks
  class StripesController < ActionController::API
    def create
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

      begin
        event = Stripe::Webhook.construct_event payload, sig_header,
                                                Settings.stripe_webhook_secret

        case event.type
        when "checkout.session.completed"
          checkout_session = event.data.object

          order = Order.find_by! stripe_checkout_session_uid: checkout_session.id
          order.complete! checkout_session
        when "checkout.session.expired"
          checkout_session = event.data.object

          order = Order.find_by! stripe_checkout_session_uid: checkout_session.id
          order.expire! checkout_session
        else
          preconditon_failure "Unhandled event type: #{event.type}"
        end
      rescue ActiveRecord::RecordNotFound => e
        Honeybadger.event "Stripe order not found", message: e.message, payload:
      rescue JSON::ParserError => e
        render json: { error: { message: e.message } }, status: :bad_request
        return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: { message: e.message, extra: "Signature verification failed" } },
               status: :bad_request
        return
      end

      head :ok
    end
  end
end
