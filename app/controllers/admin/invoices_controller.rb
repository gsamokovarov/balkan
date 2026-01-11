class Admin::InvoicesController < Admin::ApplicationController
  def index
    @invoices = scope Invoice.includes(:invoice_sequence, :order, :refunded_invoice)
  end

  def show
    @invoice = Invoice.find params[:id]

    respond_to do |format|
      format.html
      format.pdf do
        send_data @invoice.document(locale:),
                  disposition: "inline",
                  type: "application/pdf",
                  filename: @invoice.filename(locale:)
      end
    end
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(**invoice_params)
    @invoice.number = @invoice.invoice_sequence.next_invoice_number

    if @invoice.save
      redirect_to admin_invoices_path, notice: "Invoice created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @invoice = Invoice.find params[:id]

    if @invoice.update invoice_params
      redirect_to admin_invoices_path, notice: "Invoice updated"
    else
      render :show, status: :unprocessable_entity
    end
  end

  def download
    @invoice = Invoice.find params[:id]
    locale = params[:locale] || :en

    send_data @invoice.document(locale:),
              filename: @invoice.filename(locale:),
              type: "application/pdf",
              disposition: "attachment"
  end

  private

  def locale = params.fetch(:locale, I18n.locale)

  def invoice_params
    params.require(:invoice).permit(
      :invoice_sequence_id,
      :issue_date,
      :tax_event_date,
      :refunded_invoice_id,
      :customer_name,
      :customer_address,
      :customer_country,
      :customer_vat_id,
      :receiver_email,
      :receiver_company_name,
      :receiver_company_uid,
      :includes_vat,
      :notes,
      items_attributes: [:id, :description_en, :description_bg, :unit_price, :_destroy],
    )
  end
end
