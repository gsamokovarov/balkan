import { Controller } from "@hotwired/stimulus";

const TICKET_SCROLL_OFFSET = 48

// Connects to data-controller="ticket"
export default class extends Controller {

  static targets = ["tickets", "template", "summary", "buyButtonText"]
  static values = {
    count: { type: Number, default: 1 },
    price: Number
  }

  add() {
    this.countValue++
    this.ticketsTarget.insertAdjacentHTML("beforeend", this.templateTarget.outerHTML)

    const newTicket = this.ticketsTarget.lastElementChild

    const newTicketRemoveButton = newTicket.querySelector("button")
    newTicketRemoveButton.classList.remove("invisible")
    newTicketRemoveButton.classList.add("visible")

    scrollIntoViewWithOffset(newTicket, TICKET_SCROLL_OFFSET)
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
      this.summaryTarget.classList.remove("text-x-orange", "text-x-green")
      if (this.countValue === 2) this.summaryTarget.classList.add("text-x-orange")
      this.summaryTarget.textContent += ` Buy ${3 - this.countValue} more and save 10%`
    } else {
      this.summaryTarget.classList.remove("text-x-orange")
      this.summaryTarget.textContent += ` You are saving 10% (${this.calculateDiscount()})`
      this.summaryTarget.classList.add("text-x-green")
    }

    this.buyButtonTextTarget.textContent = `Pay ${this.calculatePrice()}`
  }

  calculatePrice() {
    return formatMoney(
      this.countValue < 3
        ? this.countValue * this.priceValue
        : this.countValue * this.priceValue * 0.9
    )
  }

  calculateDiscount() {
    return formatMoney(this.countValue * this.priceValue * 0.1)
  }
}

function formatMoney(value) {
  return value.toLocaleString("en-US", { style: "currency", currency: "EUR" })
}

function scrollIntoViewWithOffset(element, offset) {
  window.scrollTo({ top: element.offsetTop - offset, behavior: "smooth" })
}
