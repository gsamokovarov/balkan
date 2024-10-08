# Be sure to restart your server when you modify this file.

Rails.application.config.content_security_policy do |policy|
  policy.frame_ancestors :self, "rubybanitsa.com", "http://localhost:3000"
end
