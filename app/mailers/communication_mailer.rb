class CommunicationMailer < ApplicationMailer
  def template_email(communication, recipient_email)
    communication.interpolate_for(recipient_email) => { subject:, body: }
    @body = body

    mail to: recipient_email, subject:
  end
end
