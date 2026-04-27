Honeybadger.configure do |config|
  config.api_key = Rails.application.credentials.honeybadger_key 
  config.env = Rails.env
  config.report_data = Rails.env.production?

  config.before_notify do |notice|
    filter = ActiveSupport::ParameterFilter.new Rails.application.config.filter_parameters
    notice.params = filter.filter notice.params
  end
end
