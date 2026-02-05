class CommunicationMailer < ApplicationMailer
  def template_email(communication, recipient)
    communication.interpolate_for(recipient.email) => { subject:, body: }
    @subscriber = communication.to_subscribers? && Subscriber.find_by(email: recipient.email)
    @body = body

    mail to: recipient.email, subject:
  end
end
