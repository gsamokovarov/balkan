Rails.configuration.to_prepare do
  Admin::User.setup_credentials username: Early::ADMIN_NAME,
                                password: Early::ADMIN_PASSWORD
end
