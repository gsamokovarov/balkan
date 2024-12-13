class Admin::SchedulesController < Admin::ApplicationController
  def show
    @schedule = Schedule.find_by event_id: params[:event_id]
  end

  def new
    @schedule = Schedule.new event:
  end

  def create
    @schedule = Schedule.create event:, **schedule_params

    if @schedule.valid?
      redirect_to admin_event_schedule_path(event), notice: "Schedule created"
    else
      render :show
    end
  end

  def update
    @schedule = Schedule.find_by! params[:event_id]

    if @schedule.update schedule_params
      redirect_to admin_event_schedule_path(event), notice: "Schedule updated"
    else
      render :show
    end
  end

  private

  def event = Event.find params[:event_id]

  def schedule_params
    params.require(:schedule).permit(
      :published, slots_attributes: [[:id, :date, :time, :description, :lineup_member_id]]
    )
  end
end
