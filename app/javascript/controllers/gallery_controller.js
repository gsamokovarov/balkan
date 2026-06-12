import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gallery"
export default class extends Controller {
  static targets = ["scroller", "overlay", "overlayScroller", "counter"]
  static values = {
    interval: { type: Number, default: 5000 },
  }

  connect() {
    this.index = 0
    this.startTimer()
  }

  disconnect() {
    clearInterval(this.timer)
  }

  open() {
    clearInterval(this.timer)
    this.overlayTarget.showModal()
    this.scrollTo(this.overlayScrollerTarget, this.index, "instant")
  }

  close() {
    this.overlayTarget.close()
  }

  closed() {
    this.scrollTo(this.scrollerTarget, this.index, "instant")
    this.startTimer()
  }

  next() {
    this.show(this.index + 1)
  }

  previous() {
    this.show(this.index - 1)
  }

  // Native swipes and smooth scrolls both land here, keeping the counter and
  // the rotation timer in sync without any touch tracking of our own.
  scrolled(event) {
    const scroller = event.target
    const index = Math.round(scroller.scrollLeft / scroller.clientWidth)
    if (index === this.index) return

    this.index = index
    this.updateCounters()
    this.startTimer()
  }

  show(index) {
    this.index = (index + this.count) % this.count
    this.scrollTo(this.activeScroller, this.index, "smooth")
    this.updateCounters()
    this.startTimer()
  }

  scrollTo(scroller, index, behavior) {
    scroller.scrollTo({ left: index * scroller.clientWidth, behavior })
  }

  startTimer() {
    clearInterval(this.timer)

    if (this.count > 1 && !this.overlayTarget.open) {
      this.timer = setInterval(() => this.next(), this.intervalValue)
    }
  }

  updateCounters() {
    this.counterTargets.forEach((counter) => {
      counter.textContent = `${this.index + 1} / ${this.count}`
    })
  }

  get activeScroller() {
    return this.overlayTarget.open ? this.overlayScrollerTarget : this.scrollerTarget
  }

  get count() {
    return this.scrollerTarget.children.length
  }
}
