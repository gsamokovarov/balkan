module HCaptcha
  extend self

  def valid?(params) = verify? params["h-captcha-response"]

  private

  def verify?(token)
    return true unless Settings.h_captcha_secret

    response = request_verification token

    if response.code.to_i >= 400
      Honeybadger.event("HCaptcha error", response:)
      return false
    end

    unless response["success"]
      Honeybadger.event "Invalid captcha", error_codes: response["error-codes"]
      return false
    end

    true
  end

  def request_verification(token)
    uri = URI("https://hcaptcha.com/siteverify")
    response = Net::HTTP.post_form uri, { secret: Settings.h_captcha_secret, response: token }
    JSON.parse response.body
  rescue JSON::ParserError
    response.body
  end
end
