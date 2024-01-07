class Admin::LoginsController < Admin::ApplicationController
  layout -> { turbo_frame_request? ? "turbo_rails/frame" : "admin/login" }

  skip_before_action :require_authentication, only: [:show, :create]

  def show
    @user = Admin::User.new
  end

  def create
    @user = Admin::User.new user_params

    if @user.authenticate
      session[:admin] = true
      redirect_to admin_root_path
    else
      render :show, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:admin_user).permit :username, :password
  end
end
