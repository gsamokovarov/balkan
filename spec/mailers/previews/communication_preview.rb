require "factory_bot_rails"

# Preview all emails at http://localhost:3000/rails/mailers/communication
class CommunicationPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def template_email
    event = build :event, :balkan2024

    draft = build :communication_draft, event:, name: "Preview", subject: "Welcome to {{ event_name }}!", content: <<~MD
      # Welcome to {{ event_name }}!

      Hey {{ email }},

      We're excited to have you join us for **{{ event_name }}**! This email demonstrates how markdown is rendered in our communication system.

      ## What to Expect

      Here are some things you can look forward to:

      1. **Amazing speakers** from around the world
      2. **Hands-on workshops** to level up your skills
      3. **Networking opportunities** with fellow developers
      4. Great food and drinks throughout the event

      ### Important Links

      - [Conference Website](https://balkanruby.com)
      - [Schedule](https://balkanruby.com/schedule)
      - [Venue Information](https://balkanruby.com/venue)

      ## Event Details

      The conference will take place from **{{ event_start_date }}** to **{{ event_end_date }}** in Sofia, Bulgaria.

      ### Venue Address

      Don't forget to check out our [venue page](https://balkanruby.com/venue) for detailed directions and accommodation options nearby.

      ---

      ## Getting Ready

      Here's what you should do before the conference:

      - Review the schedule and plan which talks you want to attend
      - Join our community Slack channel
      - Prepare your questions for the speakers

      ### Code of Conduct

      We're committed to providing a *welcoming* and *inclusive* environment for everyone. Please read our [Code of Conduct](https://balkanruby.com/code-of-conduct).

      ## See You Soon!

      We can't wait to see you in {{ year }}! If you have any questions, feel free to reply to this email.

      Best regards,
      The {{ event_name }} Team

      ---

      P.S. Follow us on [Twitter](https://twitter.com/balkanruby) for the latest updates!
    MD

    communication = Communication.new(draft:)

    CommunicationMailer.template_email communication, "attendee@example.com"
  end
end
