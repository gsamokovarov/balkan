import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gallery"
//
// Rotates through a list of image URLs while keeping only a single <img> per
// view in the DOM, so 20-50+ photos stay light. Tapping the gallery opens a
// full-screen, modal-like overlay (no native fullscreen API) that reads well on
// mobile. The next image is preloaded so each swap is instant.
export default class extends Controller {
  static targets = ["image", "counter", "overlay"]
  static values = {
    urls: Array,
    interval: { type: Number, default: 5000 },
  }

  connect() {
    this.index = 0
    this.show(0)
    this.startTimer()
  }

  disconnect() {
    clearInterval(this.timer)
  }

  open() {
    this.overlayTarget.showModal()
  }

  close() {
    this.overlayTarget.close()
  }

  backdropClose(event) {
    if (event.target === this.overlayTarget) this.close()
  }

  next() {
    this.show((this.index + 1) % this.urlsValue.length)
    this.startTimer()
  }

  previous() {
    this.show((this.index - 1 + this.urlsValue.length) % this.urlsValue.length)
    this.startTimer()
  }

  startTimer() {
    clearInterval(this.timer)

    if (this.urlsValue.length > 1) {
      this.timer = setInterval(() => this.next(), this.intervalValue)
    }
  }

  show(index) {
    this.index = index
    this.imageTargets.forEach((image) => (image.src = this.urlsValue[index]))
    this.counterTargets.forEach((counter) => {
      counter.textContent = `${index + 1} / ${this.urlsValue.length}`
    })
    this.preloadNext()
  }

  preloadNext() {
    const next = (this.index + 1) % this.urlsValue.length
    const image = new Image()
    image.src = this.urlsValue[next]
  }
}
