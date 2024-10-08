class NotificationMailer < ApplicationMailer
  def sale_email(order)
    @order = order

    mail to: "genadi@hey.com", subject: "#{order.event.name} sale for #{format_money order.amount}"
  end
end
