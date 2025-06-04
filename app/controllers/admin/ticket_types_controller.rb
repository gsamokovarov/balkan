class Admin::TicketTypesController < Admin::ApplicationController
  def index
    @ticket_types = scope event.ticket_types
  end

  def show
    @ticket_type = TicketType.find params[:id]
  end

  def new
    @ticket_type = event.ticket_types.new
  end

  def create
    @ticket_type = event.ticket_types.create ticket_type_params

    if @ticket_type.valid?
      redirect_to admin_event_ticket_types_path(event), notice: "Ticket type created"
    else
      render :new
    end
  end

  def edit
    @ticket_type = TicketType.find params[:id]
  end

  def update
    @ticket_type = TicketType.find params[:id]

    if @ticket_type.update ticket_type_params
      redirect_to admin_event_ticket_types_path(event), notice: "Ticket type updated"
    else
      render :edit
    end
  end

  private

  def ticket_type_params = params.require(:ticket_type).permit(:event_id, :name, :description, :price, :enabled)
  def event = Event.find(params[:event_id])
end
