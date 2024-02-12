Rails.configuration.to_prepare do
  Admin::User.setup_credentials username: Settings.admin_name,
                                password: Settings.admin_password
end
