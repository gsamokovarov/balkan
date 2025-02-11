import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navigation"
export default class extends Controller {
  static targets = ["menu", "openIcon", "closeIcon"]

  static values = {
    open: { type: Boolean, default: false },
  }

  collapse = () => {
    this.openValue = false
  }

  connect() {
    document.addEventListener("turbo:before-cache", this.collapse)
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.collapse)
  }

  toggleOpen() {
    this.openValue = !this.openValue
  }

  openValueChanged(open) {
    const headerClasses = ["fixed", "inset-0", "overflow-y-auto"]

    document.body.classList.toggle("overflow-hidden", open)

    this.menuTarget.classList.toggle("flex", open)
    this.menuTarget.classList.toggle("hidden", !open)

    if (open) {
      this.element.classList.add(...headerClasses)
      this.openIconTarget.classList.add("hidden")
      this.closeIconTarget.classList.remove("hidden")
    } else {
      this.element.classList.remove(...headerClasses)
      this.openIconTarget.classList.remove("hidden")
      this.closeIconTarget.classList.add("hidden")
    }
  }
}
