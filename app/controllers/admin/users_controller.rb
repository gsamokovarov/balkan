class Admin::UsersController < Admin::ApplicationController
  def index
    @users = scope User.all
  end

  def show
    @user = User.find params[:id]
    @sessions = @user.sessions.order(id: :desc).page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.role = role_param if role_param

    if @user.save
      redirect_to admin_users_path, notice: "User was created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find params[:id]
    @user.assign_attributes user_params
    @user.role = role_param if role_param

    if @user.save
      redirect_to admin_users_path, notice: "User was updated"
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find params[:id]
    user.destroy

    redirect_to admin_users_path, notice: "User #{user.email} was deleted"
  end

  private

  def user_params = params.require(:user).permit :name, :email, :password, :bio, :avatar
  def role_param  = Current.user&.organizer? ? params.dig(:user, :role).presence : nil
end
