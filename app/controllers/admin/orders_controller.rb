class Admin::OrdersController < Admin::ApplicationController
  def show
    @order = Order.completed.includes(tickets: :ticket_type).find params[:id]

    respond_to do |format|
      format.html
      format.pdf do
        send_data @order.invoice.document(locale:),
                  disposition: "inline",
                  type: "application/pdf",
                  filename: @order.invoice.filename(locale:)
      end
    end
  end

  def report
    orders = Order.where("completed_at IS NOT NULL").order("completed_at DESC")
    report = Order::Report.export_csv orders

    send_data report, filename: "orders-#{Date.current.iso8601}.csv", type: :csv
  end

  def invoice
    @order = Order.completed.includes(tickets: :ticket_type).find params[:id]

    OrderMailer.invoice_email(@order).deliver_later
  end

  private def locale = params.fetch(:locale, I18n.locale)
end
