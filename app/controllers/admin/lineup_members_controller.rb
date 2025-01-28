class Admin::LineupMembersController < Admin::ApplicationController
  def index
    @lineup_members = event.lineup_members.includes :talk, :speaker
  end

  def show
    @lineup_member = LineupMember.find params[:id]
  end

  def new
    @lineup_member = event.lineup_members.new
  end

  def create
    @lineup_member = event.lineup_members.new(**lineup_member_params)

    if @lineup_member.save
      redirect_to admin_event_lineup_members_path(@lineup_member.event), notice: "Lineup member created"
    else
      render :new
    end
  end

  def edit
    @lineup_member = LineupMember.find params[:id]
  end

  def update
    @lineup_member = LineupMember.find params[:id]

    if @lineup_member.update lineup_member_params
      redirect_to admin_event_lineup_members_path(@lineup_member.event), notice: "Lineup member updated"
    else
      render :show
    end
  end

  private

  def lineup_member_params = params.require(:lineup_member).permit(:event_id, :speaker_id, :talk_id, :role, :status)
  def event = Event.find(params[:event_id])
end
