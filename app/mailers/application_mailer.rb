class ApplicationMailer < ActionMailer::Base
  include MailHelper
  include MarkdownHelper

  helper MailHelper
  helper MarkdownHelper

  default from: email_address_with_name("genadi@balkanruby.com", "Genadi Samokovarov")

  layout "mailer"

  private

  def attach_event_logo(event)
    attachments.inline["logo.png"] = event.logo.download if event.logo.attached?
  end
end
