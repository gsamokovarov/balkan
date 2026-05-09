import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["source"]

  copy(event) {
    event.preventDefault()

    navigator.clipboard.writeText(this.sourceTarget.textContent.trim())

    const button = event.currentTarget
    const original = button.textContent
    button.textContent = "Copied!"
    setTimeout(() => { button.textContent = original }, 2000)
  }
}
