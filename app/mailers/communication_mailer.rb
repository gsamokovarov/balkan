class CommunicationMailer < ApplicationMailer
  def template_email(communication, recipient)
    attach_event_logo communication.event

    communication.interpolate_for(recipient.email) => { subject:, body: }
    @subscriber = communication.to_subscribers? && Subscriber.find_by(email: recipient.email)
    @body = body
    @sponsor_attachments =
      if communication.with_sponsors?
        communication.event.sponsors.filter_map do |sponsorship|
          filename = "sponsor-#{sponsorship.id}.png"
          attachments.inline[filename] = sponsorship.sponsor.logo.variant(resize_to_limit: [200, 200], format: :png).processed.download
          { name: sponsorship.sponsor.name, filename: }
        end
      end

    mail to: recipient.email, subject:
  end
end
