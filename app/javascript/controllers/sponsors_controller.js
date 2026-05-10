import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sponsors"
export default class extends Controller {
  static targets = ["image"]
  static values = {
    images: Array,
  }

  connect() {
    const image = this.imageTarget
    this.originalSrc = image.src
    this.sponsorIndex = 0
    this.showingOriginal = true

    this.rotateIntervalHandler = setInterval(() => {
      if (this.showingOriginal) {
        image.src = this.imagesValue[this.sponsorIndex]
        this.sponsorIndex = (this.sponsorIndex + 1) % this.imagesValue.length
        this.showingOriginal = false
      } else {
        image.src = this.originalSrc
        this.showingOriginal = true
      }
    }, 10000)
  }

  disconnect() {
    clearInterval(this.rotateIntervalHandler)
  }
}
