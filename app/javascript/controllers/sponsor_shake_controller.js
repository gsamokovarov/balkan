import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sponsor-shake"
export default class extends Controller {
  connect() {
    if (this.prefersReducedMotion) {
      this.element.classList.add("shadow-brutal")
      return
    }

    this.observer = new IntersectionObserver(this.onIntersect.bind(this), { threshold: 0.3 })
    this.observer.observe(this.element)
  }

  disconnect() {
    this.observer?.disconnect()
  }

  onIntersect(entries) {
    for (const entry of entries) {
      if (!entry.isIntersecting) continue

      this.element.classList.add("animate-seismic-slam", "shadow-brutal")
      this.observer.disconnect()
    }
  }

  get prefersReducedMotion() {
    return window.matchMedia("(prefers-reduced-motion: reduce)").matches
  }
}
