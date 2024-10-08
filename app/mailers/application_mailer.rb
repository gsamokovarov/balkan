class ApplicationMailer < ActionMailer::Base
  include MailHelper
  helper MailHelper

  default from: email_address_with_name("genadi@hey.com", "Genadi Samokovarov")

  layout "mailer"
end
