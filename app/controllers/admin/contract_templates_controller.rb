class Admin::ContractTemplatesController < Admin::ApplicationController
  def index
    @contract_templates = scope event.contract_templates
  end

  def show
    @contract_template = event.contract_templates.find params[:id]
  end

  def new
    @contract_template = event.contract_templates.new
  end

  def create
    @contract_template = event.contract_templates.new(**contract_template_params)

    if @contract_template.save
      redirect_to admin_event_contract_template_path(event, @contract_template), notice: "Contract template created"
    else
      render :new
    end
  end

  def edit
    @contract_template = event.contract_templates.find params[:id]
  end

  def update
    @contract_template = event.contract_templates.find params[:id]

    if @contract_template.update contract_template_params
      redirect_to admin_event_contract_template_path(event, @contract_template), notice: "Contract template updated"
    else
      render :show
    end
  end

  private

  def event = @event ||= Event.find(params[:event_id])

  def contract_template_params = params.require(:contract_template).permit(:name, :content)
end
