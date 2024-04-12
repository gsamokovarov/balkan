import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="hero"
export default class extends Controller {
  scrollToTickets() {
    const ticketsElement = document.getElementById("tickets")
    if (ticketsElement) ticketsElement.scrollIntoView({ behavior: "smooth" })
  }
}
