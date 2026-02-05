class CommunicationMailer < ApplicationMailer
  def template_email(communication, recipient)
    communication.interpolate_for(recipient.email) => { subject:, body: }
    @communication = communication
    @recipient = recipient
    @body = body

    mail to: recipient.email, subject:
  end
end
