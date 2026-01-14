module Support
  module AuthenticationHelper
    def sign_in(user)
      session = user.sessions.create!
      key_generator = Rails.application.key_generator
      secret = key_generator.generate_key Rails.application.config.action_dispatch.signed_cookie_salt
      verifier = ActiveSupport::MessageVerifier.new secret, digest: "SHA1", serializer: ActiveSupport::MessageEncryptor::NullSerializer
      cookies[:session_id] = verifier.generate session.id.to_s
    end
  end
end
