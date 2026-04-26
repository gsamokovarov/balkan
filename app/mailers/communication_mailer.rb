class CommunicationMailer < ApplicationMailer
  def template_email(communication, recipient)
    communication.interpolate_for(recipient.email) => { subject:, body: }
    @subscriber = communication.to_subscribers? && Subscriber.find_by(email: recipient.email)
    @body = body
    @sponsor_attachments =
      if communication.with_sponsors?
        communication.event.sponsors.filter_map do |sponsorship|
          filename = "sponsor-#{sponsorship.id}-#{sponsorship.sponsor.logo.filename}"
          attachments.inline[filename] = sponsorship.sponsor.logo.download
          { name: sponsorship.sponsor.name, filename: }
        end
      end

    mail to: recipient.email, subject:
  end
end
