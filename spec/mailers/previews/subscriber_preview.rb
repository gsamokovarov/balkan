require "factory_bot_rails"

# Preview all emails at http://localhost:3000/rails/mailers/subscriber
class SubscriberPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def welcome_email
    subscriber = build :subscriber, email: "genadi@hey.com"

    SubscriberMailer.welcome_email(subscriber).deliver_now
  end

  def newsletter_1_email
    subscriber = build :subscriber, email: "genadi@hey.com"

    SubscriberMailer.newsletter_1_email(subscriber).deliver_now
  end
end
