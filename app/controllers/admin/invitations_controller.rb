class Admin::InvitationsController < Admin::ApplicationController
  allow_unauthenticated_access only: [:show, :update]

  layout -> { turbo_frame_request? ? "turbo_rails/frame" : "admin/login" }

  def show
    @user = User.find_by_token_for! :invitation, params[:id]
  rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound
    redirect_to admin_login_path, alert: "Invitation link is invalid or expired"
  end

  def update
    @user = User.find_by_token_for! :invitation, params[:id]

    if @user.update password_params
      start_new_session_for @user
      redirect_to admin_root_path, notice: "Welcome!"
    else
      render :show, status: :unprocessable_entity
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound
    redirect_to admin_login_path, alert: "Invitation link is invalid or expired"
  end

  private

  def password_params = params.require(:user).permit(:password, :password_confirmation)
end
