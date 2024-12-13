class Admin::SchedulesController < Admin::ApplicationController
  def show
    @schedule = event.schedule
  end

  def new
    @schedule = event.build_schedule
  end

  def create
    @schedule = event.create_schedule schedule_params

    if @schedule.valid?
      redirect_to admin_event_schedule_path(event), notice: "Schedule created"
    else
      render :show
    end
  end

  def update
    @schedule = event.schedule

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
