class SubscriberMailer < ApplicationMailer
  def welcome_email(subscriber)
    @subscriber = subscriber

    mail to: @subscriber.email, subject: "Welcome to Balkan Ruby newsletter!"
  end

  def newsletter_1_email(subscriber)
    @subscriber = subscriber

    mail to: @subscriber.email, subject: "Get ready for Balkan Ruby 2024"
  end
end
