class ApplicationMailer < ActionMailer::Base
  include MailHelper
  include MarkdownHelper

  helper MailHelper
  helper MarkdownHelper

  default from: email_address_with_name("genadi@balkanruby.com", "Genadi Samokovarov")

  layout "mailer"
end
