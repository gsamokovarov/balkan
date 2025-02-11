import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expand"
export default class extends Controller {
  static targets = ["target"]

  toggle() {
    this.targetTarget.classList.toggle("hidden")
  }
}
