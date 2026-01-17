class OrderMailer < ApplicationMailer
  def invoice_email(order)
    precondition order.invoice

    @order = order
    @invoice = order.invoice

    attachments[@invoice.filename(locale: :en)] = @invoice.document locale: :en
    attachments[@invoice.filename(locale: :bg)] = @invoice.document locale: :bg

    mail to: @order.email, subject: "#{@order.event.name} invoice"
  end

  def refund_email(order)
    @order = order
    @credit_note = order.credit_note

    if @credit_note
      attachments[@credit_note.filename(locale: :en)] = @credit_note.document locale: :en
      attachments[@credit_note.filename(locale: :bg)] = @credit_note.document locale: :bg
    end

    mail to: @order.email, subject: "#{@order.event.name} refund"
  end
end
