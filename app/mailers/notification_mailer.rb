class NotificationMailer < ApplicationMailer
  def sale_email(order)
    @order = order

    mail to: "genadi@hey.com", subject: "Balkan Ruby sale for #{format_money order.amount}"
  end
end
