class ApplicationMailer < ActionMailer::Base
  default from: "genadi@balkanruby.com"

  helper MailHelper

  layout "mailer"
end
