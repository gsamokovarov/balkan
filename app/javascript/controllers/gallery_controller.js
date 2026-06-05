import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gallery"
export default class extends Controller {
  static targets = ["image", "counter"]
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
    this.imageTarget.src = this.urlsValue[index]

    if (this.hasCounterTarget) {
      this.counterTarget.textContent = `${index + 1} / ${this.urlsValue.length}`
    }

    this.preloadNext()
  }

  preloadNext() {
    const next = (this.index + 1) % this.urlsValue.length
    const image = new Image()
    image.src = this.urlsValue[next]
  }
}
