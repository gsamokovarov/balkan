class SelectionMailer < ApplicationMailer
  def waitinglist_email(speaker)
    @speaker = speaker

    mail to: @speaker.email, subject: "Balkan Ruby 2024 –  talk in waitinglist"
  end
end
