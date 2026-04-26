class ApplicationMailer < ActionMailer::Base
  include MailHelper
  include MarkdownHelper

  helper MailHelper
  helper MarkdownHelper

  default from: email_address_with_name("genadi@balkanruby.com", "Genadi Samokovarov")

  layout "mailer"

  private

  def attach_event_logo(event)
    return unless event.logo.attached?

    attachments.inline["logo.png"] = event.logo.variant(resize_to_limit: [200, 200], format: :png).processed.download
  end
end
