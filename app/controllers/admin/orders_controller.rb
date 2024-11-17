class Admin::OrdersController < Admin::ApplicationController
  def index
    @orders = Order.completed.includes(:event, :invoice, :tickets).order("completed_at DESC")
  end

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
    orders = Order.completed.includes(:invoice, tickets: :ticket_type).order("completed_at DESC")

    respond_to do |format|
      format.csv do
        report = Order::Reporting.export_to_csv orders
        send_data report, filename: "orders-#{Date.current.iso8601}.csv", type: :csv
      end
      format.tar do
        report = Order::Reporting.export_invoices_to_tar orders
        send_data report, filename: "invoices-#{Date.current.iso8601}.tar", type: :tar
      end
    end
  end

  def invoice
    @order = Order.completed.includes(tickets: :ticket_type).find params[:id]

    OrderMailer.invoice_email(@order).deliver_later
  end

  private def locale = params.fetch(:locale, I18n.locale)
end
