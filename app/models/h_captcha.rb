module HCaptcha
  extend self

  def valid?(params) = verify? params["h-captcha-response"]

  private

  def verify?(token)
    return true unless Settings.h_captcha_secret

    response = request_verification token
    response["success"].tap do |success|
      Honeybadger.event "Invalid captcha", error_codes: response["error-codes"] unless success
    end
  end

  def request_verification(token)
    uri = URI("https://hcaptcha.com/siteverify")
    response = Net::HTTP.post_form uri, { secret: Settings.h_captcha_secret, response: token }
    JSON.parse response.body
  end
end
