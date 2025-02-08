class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.order(id: :desc).page params[:page]
  end

  def show
    @user = User.find params[:id]
    @sessions = @user.sessions.order(id: :desc).page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create user_params
    if @user.valid?
      redirect_to admin_users_path, notice: "User was created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find params[:id]

    if @user.update user_params
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

  def user_params = params.require(:user).permit :email, :password
end
