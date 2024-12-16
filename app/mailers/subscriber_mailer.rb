class SubscriberMailer < ApplicationMailer
  def welcome_email(subscriber)
    @subscriber = subscriber

    mail to: @subscriber.email, subject: "Welcome to #{@subscriber.event.name} newsletter!"
  end

  def newsletter_1_email(subscriber)
    @subscriber = subscriber

    mail to: @subscriber.email, subject: "Get ready for Balkan Ruby 2024"
  end

  def newsletter_2_email(subscriber)
    @subscriber = subscriber

    mail to: @subscriber.email, subject: "Balkan Ruby 2024 in a new venue"
  end

  def newsletter_10_email(subscriber)
    @subscriber = subscriber

    mail to: @subscriber.email, subject: "Get ready for Balkan Ruby 2025"
  end
end
