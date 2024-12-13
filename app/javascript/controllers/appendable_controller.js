import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="appendable"
export default class extends Controller {
  static targets = ["template", "target", "append"]

  add() {
    const elementCopy = this.templateTarget.content.cloneNode(true)
    this.targetTarget.appendChild(elementCopy)
  }

  remove(event) {
    const currentItem = event.currentTarget.parentElement

    currentItem.remove()
  }
}
