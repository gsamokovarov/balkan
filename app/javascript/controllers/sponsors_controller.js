import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="sponsors"
export default class extends Controller {
  static targets = ["image"]
  static values = {
    sponsorSrc: String
  }

  connect() {
    const image = this.imageTarget
    const originalSrc = image.src

    this.rotateIntervalHandler = setInterval(() => {
      if (image.src === originalSrc) {
        image.src = this.sponsorSrcValue
      } else {
        image.src = originalSrc
      }
    }, 10000)
  }

  disconnect() {
    clearInterval(this.rotateIntervalHandler)
  }
}
