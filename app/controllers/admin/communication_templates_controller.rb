class Admin::CommunicationTemplatesController < Admin::ApplicationController
  def index
    @templates = scope CommunicationTemplate.all
  end

  def show
    @template = CommunicationTemplate.find(params[:id])
  end

  def new
    @template = CommunicationTemplate.new
  end

  def create
    @template = CommunicationTemplate.create template_params

    if @template.valid?
      redirect_to admin_communication_templates_path, notice: "Template created"
    else
      render :new
    end
  end

  def edit
    @template = CommunicationTemplate.find(params[:id])
  end

  def update
    @template = CommunicationTemplate.find(params[:id])

    if @template.update(template_params)
      redirect_to admin_communication_templates_path, notice: "Template updated"
    else
      render :edit
    end
  end

  def destroy
    @template = CommunicationTemplate.find(params[:id])
    @template.destroy

    redirect_to admin_communication_templates_path, notice: "Template deleted"
  end

  def preview
    @template = CommunicationTemplate.find(params[:id])
    @rendered = @template.preview

    render json: @rendered
  end

  private

  def template_params
    params.require(:communication_template).permit(
      :name,
      :description,
      :subject_template,
      :content_template
    )
  end
end
