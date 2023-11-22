import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="ticket"
export default class extends Controller {
  static targets = ["tickets", "template", "summary", "buyButtonText"]
  static values = { count: { type: Number, default: 1 } }

  add() {
    this.countValue++
    this.ticketsTarget.insertAdjacentHTML("beforeend", this.templateTarget.outerHTML)

    const newTicket = this.ticketsTarget.lastElementChild

    const newTicketRemoveButton = newTicket.querySelector("button")
    newTicketRemoveButton.classList.remove("invisible")
    newTicketRemoveButton.classList.add("visible")

    newTicket.scrollIntoView({ behavior: "smooth" })
  }

  remove(event) {
    const removeButton = event.currentTarget
    if (removeButton.disabled) return

    if (this.countValue > 1) {
      removeButton.disabled = true
      this.countValue--

      const currentTicket = removeButton.parentElement
      currentTicket.classList.add("transition-opacity", "duration-500", "opacity-0")
      setTimeout(() => currentTicket.remove(), 500)
    }
  }

  countValueChanged() {
    this.summaryTarget.textContent = `You are about to buy ${this.countValue} ticket${this.countValue > 1 ? "s" : ""}.`
    if (this.countValue < 3) {
      this.summaryTarget.textContent += ` Buy ${3 - this.countValue} more and save 10%`
    } else {
      this.summaryTarget.textContent += ` You are saving 10%`
      this.summaryTarget.classList.add("text-x-orange")
    }

    this.buyButtonTextTarget.textContent = `Buy ${this.countValue} ticket${this.countValue > 1 ? "s" : ""}`
  }
}
