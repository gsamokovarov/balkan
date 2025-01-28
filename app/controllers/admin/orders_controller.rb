class Admin::OrdersController < Admin::ApplicationController
  def index
    @orders = Order.completed.includes(:event, :invoice, :tickets).order("completed_at DESC").page(params[:page])
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

  def update
    @order = Order.completed.find params[:id]

    if @order.update order_params
      redirect_to admin_orders_path, notice: "Order updated"
    else
      render :show
    end
  end

  def report
    orders =
      Order.completed
        .includes(:invoice, tickets: :ticket_type)
        .where(created_at: Date.current.prev_month.beginning_of_month..)
        .order("completed_at DESC")

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

  private

  def locale = params.fetch(:locale, I18n.locale)

  def order_params
    params.require(:order).permit(:name, :email, :amount, :refunded_amount, :issue_invoice, :free_reason, :invoice_id)
  end
end
