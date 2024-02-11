class InvoiceMailer < ApplicationMailer
  def issue_email(order)
    precondition order.invoice

    @order = order
    @invoice = order.invoice

    attachments[@invoice.filename(locale: :en)] = @invoice.document(locale: :en)
    attachments[@invoice.filename(locale: :bg)] = @invoice.document(locale: :bg)

    mail to: @order.email, subject: "Balkan Ruby invoice"
  end
end
