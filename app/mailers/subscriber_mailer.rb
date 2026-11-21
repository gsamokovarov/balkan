class SubscriberMailer < ApplicationMailer
  def welcome_email(subscriber)
    @subscriber = subscriber

    mail to: @subscriber.email, subject: "Welcome to #{Current.event.name} newsletter!"
  end
end
