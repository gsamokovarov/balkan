module HCaptchaHelper
  def h_captcha
    return "".html_safe unless Settings.h_captcha_site_key

    capture do
      concat tag.div(class: "h-captcha", data: { sitekey: Settings.h_captcha_site_key, controller: "h-captcha" })
      concat tag.script(src: "https://hcaptcha.com/1/api.js", async: true, defer: true)
    end
  end
end
