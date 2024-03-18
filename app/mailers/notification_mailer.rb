class NotificationMailer < ApplicationMailer
  default from: email_address_with_name("notifications@balkanruby.com", "Balkan Ruby")

  def sale_email(order)
    @order = order

    mail to: "genadi@hey.com", subject: "Balkan Ruby sale for #{format_money order.amount}"
  end
end
