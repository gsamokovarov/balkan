import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["source", "indicator"]

  copy() {
    event.preventDefault()

    const copiedValue = this.sourceTarget.textContent.trim()

    navigator.clipboard.writeText(copiedValue)
    this.indicate(copiedValue)
  }

  indicate(copiedValue) {
    const previousHTML = this.indicatorTarget.innerHTML
    this.indicatorTarget.innerHTML = `Copied <b>${copiedValue}</b> to clipboard!`
    setTimeout(() => {
      this.indicatorTarget.innerHTML = previousHTML
    }, 5000)
  }
}
