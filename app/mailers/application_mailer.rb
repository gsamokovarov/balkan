class ApplicationMailer < ActionMailer::Base
  helper MailHelper

  default from: email_address_with_name("genadi@balkanruby.com", "Genadi Samokovarov")
  before_action :set_inline_logo

  layout "mailer"

  private

  def set_inline_logo
    attachments.inline["logo.png"] = Rails.root.join("app/assets/images/logo-email.png").read
  end
end
