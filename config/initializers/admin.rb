Rails.configuration.to_prepare do
  Admin::ApplicationController.admin_name = Early::ADMIN_NAME
  Admin::ApplicationController.admin_password = Early::ADMIN_PASSWORD
end
