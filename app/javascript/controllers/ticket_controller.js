import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="ticket"
export default class extends Controller {
  static targets = ["tickets", "template", "buyText"]
  static values = { count: { type: Number, default: 1 } }

  add() {
    this.countValue++
    this.ticketsTarget.insertAdjacentHTML("beforeend", this.templateTarget.outerHTML)
  }

  countValueChanged() {
    console.log(this.countValue)
    this.buyTextTarget.textContent = `Buy ${this.countValue} tickets`
  }
}
