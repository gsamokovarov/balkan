class HuntMailer < ApplicationMailer
  def invite_email(email:, password:, magic_link:)
    @email = email
    @password = password
    @magic_link = magic_link

    mail to: email, subject: "Your Balkan Ruby 2026 treasure hunt credentials"
  end
end
