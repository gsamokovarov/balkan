class Admin::ApplicationController < ApplicationController
  layout -> { turbo_frame_request? ? "turbo_rails/frame" : "admin/application" }

  before_action :require_authentication

  private

  def require_authentication
    redirect_to admin_login_path unless session[:admin]
  end
end
