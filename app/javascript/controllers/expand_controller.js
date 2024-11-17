import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="navigation"
export default class extends Controller {
  static targets = ["target"];

  toggle() {
    this.targetTarget.classList.toggle("hidden")
  }
}
