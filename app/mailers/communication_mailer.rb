class CommunicationMailer < ApplicationMailer
  def campaign_email(communication, recipient_email)
    @communication = communication
    @recipient_email = recipient_email
    @rendered = communication.render_for recipient_email

    mail to: recipient_email, subject: @rendered[:subject] do |format|
      format.html { render inline: @rendered[:body] }
    end
  end
end
