class Admin::ApplicationController < ApplicationController
  layout "admin/application"

  cattr_accessor :admin_name
  cattr_accessor :admin_password

  before_action :authenticate_admin

  private

  def authenticate_admin
    authenticate_or_request_with_http_basic do |name, password|
      ActiveSupport::SecurityUtils.secure_compare(name, admin_name) &
        ActiveSupport::SecurityUtils.secure_compare(password, admin_password)
    end

    cookies.signed[:admin] = { value: true, expires: 3.months }
  end
end
