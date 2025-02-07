import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="h-captcha"
export default class extends Controller {
  connect() {
    window.hcaptcha?.render(this.element)
  }

  disconnect() {
    this.element.replaceChildren()
  }
}
