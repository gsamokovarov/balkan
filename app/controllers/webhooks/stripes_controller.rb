module Webhooks
  class StripesController < ActionController::API
    def create
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, Early::STRIPE_WEBHOOK_SECRET
        )

        case event.type
        when 'checkout.session.completed'
          checkout_session = event.data.object

          order = Order.find_by!(stripe_checkout_session_uid: checkout_session.id)
          order.update! completed_at: Time.current,
                        email: checkout_session.customer_details&.email || "unknown@email.com",
                        stripe_checkout_session: checkout_session.to_h

          order.tickets.each do
            TicketMailer.welcome_email(_1).deliver_now
          end
        when 'checkout.session.expired'
          checkout_session = event.data.object

          order = Order.find_by!(stripe_checkout_session_uid: checkout_session.id)
          order.update! expired_at: Time.current,
                        email: checkout_session.customer_details&.email || "unknown@email.com",
                        stripe_checkout_session: checkout_session.to_h
        else
          preconditon_failure "Unhandled event type: #{event.type}"
        end
      rescue JSON::ParserError => e
        render json: { error: { message: e.message } }, status: :bad_request
        return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: { message: e.message, extra: 'Signature verification failed' } },
               status: :bad_request
        return
      end

      head :ok
    end
  end
end
