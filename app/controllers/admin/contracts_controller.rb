class Admin::ContractsController < Admin::ApplicationController
  def index
    @contracts = scope event.contracts.includes(:contract_template)
  end

  def new
    @contract = event.contracts.new date: Date.current
  end

  def create
    @contract = event.contracts.new(**contract_params)

    if @contract.save
      redirect_to admin_event_contract_path(event, @contract), notice: "Contract created"
    else
      render :new
    end
  end

  def show
    @contract = event.contracts.find params[:id]

    respond_to do |format|
      format.html
      format.pdf do
        send_data @contract.document, disposition: "inline", type: "application/pdf", filename: @contract.filename
      end
    end
  end

  def update
    @contract = event.contracts.find params[:id]

    if @contract.update contract_params
      redirect_to admin_event_contracts_path(event), notice: "Contract updated"
    else
      render :show
    end
  end

  def download
    @contract = event.contracts.find params[:id]

    send_data @contract.document, filename: @contract.filename, type: "application/pdf", disposition: "attachment"
  end

  def destroy
    @contract = event.contracts.find params[:id]
    @contract.destroy

    redirect_to admin_event_contracts_path(event), notice: "Contract deleted"
  end

  private

  def event = @event ||= Event.find(params[:event_id])

  def contract_params
    params.require(:contract).permit(:contract_template_id,
                                     :date,
                                     :price,
                                     :company_name,
                                     :company_address,
                                     :company_country,
                                     :company_id_number,
                                     :company_vat_id,
                                     :representative_name,
                                     :perks)
  end
end
