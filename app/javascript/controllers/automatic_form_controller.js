import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="automatic-form"
export default class extends Controller {
  connect() {
    this.inputElements = this.element.querySelectorAll("input, select, textarea")

    this.inputElements.forEach(input => {
      input.addEventListener("change", this.submitForm.bind(this))
    })
  }

  disconnect() {
    this.inputElements.forEach(input => {
      input.removeEventListener("change", this.submitForm.bind(this))
    })
  }

  submitForm() {
    this.element.requestSubmit()
  }
}
