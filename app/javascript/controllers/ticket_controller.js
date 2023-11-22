import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="ticket"
export default class extends Controller {
  static targets = ["tickets", "template"]

  add() {
    this.ticketsTarget.insertAdjacentHTML("beforeend", this.templateTarget.outerHTML)
  }
}
