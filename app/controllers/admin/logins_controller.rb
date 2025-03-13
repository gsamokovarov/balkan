class Admin::LoginsController < Admin::ApplicationController
  skip_before_action :set_current
  allow_unauthenticated_access only: [:show, :create]

  layout -> { turbo_frame_request? ? "turbo_rails/frame" : "admin/login" }

  def show
    @user = User.new
  end

  def create
    @user = User.authenticate_by(user_params) || User.new { it.errors.add :base, "Invalid username or password" }

    if @user.valid?
      start_new_session_for @user
      redirect_to after_authentication_url
    else
      render :show, status: :unauthorized
    end
  end

  private

  def user_params = params.require(:user).permit :email, :password
end
