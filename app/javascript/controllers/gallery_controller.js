import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gallery"
export default class extends Controller {
  static targets = ["image", "counter", "overlay", "preload"]
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
    clearInterval(this.timer)
    this.overlayTarget.showModal()
  }

  close() {
    this.overlayTarget.close()
  }

  closed() {
    this.startTimer()
  }

  swipeStart(event) {
    this.multiTouch = event.touches.length > 1
    if (this.multiTouch) return

    const touch = event.changedTouches[0]
    this.swipeStartX = touch.clientX
    this.swipeStartY = touch.clientY
  }

  swipeEnd(event) {
    if (this.multiTouch || event.touches.length > 0) return
    if (window.visualViewport && window.visualViewport.scale > 1) return

    const touch = event.changedTouches[0]
    const deltaX = touch.clientX - this.swipeStartX
    const deltaY = touch.clientY - this.swipeStartY

    // Ignore taps and mostly-vertical gestures (those are page scrolls).
    if (Math.abs(deltaX) < 40 || Math.abs(deltaX) < Math.abs(deltaY)) return

    if (deltaX < 0) this.next()
    else this.previous()
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

    if (this.urlsValue.length > 1 && !this.overlayTarget.open) {
      this.timer = setInterval(() => this.next(), this.intervalValue)
    }
  }

  show(index) {
    this.index = index
    this.imageTargets.forEach((image) => (image.src = this.urlsValue[index]))
    this.counterTargets.forEach((counter) => {
      counter.textContent = `${index + 1} / ${this.urlsValue.length}`
    })
    this.preloadNeighbors()
  }

  preloadNeighbors() {
    const length = this.urlsValue.length
    if (length < 2) return

    this.preloadTargets[0].href = this.urlsValue[(this.index + 1) % length]
    this.preloadTargets[1].href = this.urlsValue[(this.index - 1 + length) % length]
  }
}
