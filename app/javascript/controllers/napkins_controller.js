import { Controller } from "@hotwired/stimulus"

const GRAVITY = 520
const SHEET = new Path2D("M-1 -1H1V1H-1Z")
const CREASES = new Path2D("M0 -1V1M-1 0H1")
const EMBOSS = new Path2D("M-.72 -.72H.72V.72H-.72Z")

// Connects to data-controller="napkins"
export default class extends Controller {
  static targets = ["canvas"]

  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return

    const style = getComputedStyle(this.element)

    this.colors = {
      front: style.getPropertyValue("--brand-card"),
      back: style.getPropertyValue("--brand-100"),
      crease: style.getPropertyValue("--brand-200"),
      emboss: style.getPropertyValue("--brand-300"),
      line: style.getPropertyValue("--brand-line"),
    }
    this.napkins = []
    this.pen = this.canvasTarget.getContext("2d")

    this.observer = new ResizeObserver(() => this.resize())
    this.observer.observe(document.documentElement)
    this.observer.observe(this.element)
    this.resize()

    for (let index = 0; index < 60; index++) {
      this.add({ x: random(0, this.width), y: random(-1.6 * window.innerHeight, -40), vx: 0, vy: 100 })
    }
  }

  disconnect() {
    this.observer?.disconnect()
    cancelAnimationFrame(this.frame)
    this.frame = null
  }

  throw({ currentTarget }) {
    const from = currentTarget.getBoundingClientRect()
    const page = this.canvasTarget.getBoundingClientRect()

    for (let index = 0; index < 16; index++) {
      this.add({
        x: from.left - page.left + from.width / 2,
        y: from.top - page.top,
        vx: random(-520, 520),
        vy: random(-1900, -900),
      })
    }
  }

  add(napkin) {
    this.napkins.push({
      ...napkin,
      size: random(15, 27),
      float: random(60, 100),
      sway: random(0, 6),
      angles: [random(0, 360), random(0, 360), random(0, 360)],
      spins: [random(-190, 190), random(-120, 120), random(-60, 60)],
    })

    this.frame ||= requestAnimationFrame((now) => this.tick(now))
  }

  tick(now) {
    const seconds = Math.min((now - (this.previous ?? now)) / 1000, 0.05)

    this.previous = now
    this.pen.clearRect(0, 0, this.width, this.height)
    this.napkins = this.napkins.filter((napkin) => napkin.y < this.height + napkin.size * 2)

    this.napkins.forEach((napkin) => {
      const matrix = new DOMMatrix().translate(napkin.x, napkin.y).rotate(...napkin.angles).scale(napkin.size)

      this.draw(matrix)
      this.move(napkin, 2 - Math.abs(matrix.m33), seconds)
    })

    this.frame = this.napkins.length > 0 ? requestAnimationFrame((now) => this.tick(now)) : null
  }

  move(napkin, slip, seconds) {
    napkin.sway += 1.7 * seconds
    napkin.vx += (55 * Math.cos(napkin.sway) - napkin.vx) * 2.2 * seconds
    napkin.vy += GRAVITY * (1 - napkin.vy / (napkin.float * slip)) * seconds
    napkin.x += napkin.vx * seconds
    napkin.y += napkin.vy * seconds
    napkin.angles = napkin.angles.map((angle, index) => angle + napkin.spins[index] * seconds)
  }

  draw(matrix) {
    const [sheet, creases, emboss] = [SHEET, CREASES, EMBOSS].map((shape) => {
      const path = new Path2D()
      path.addPath(shape, matrix)
      return path
    })

    this.pen.fillStyle = matrix.m33 > 0 ? this.colors.front : this.colors.back
    this.pen.fill(sheet)

    this.pen.lineWidth = 1
    this.pen.strokeStyle = this.colors.crease
    this.pen.stroke(creases)

    this.pen.setLineDash([2, 3])
    this.pen.strokeStyle = this.colors.emboss
    this.pen.stroke(emboss)
    this.pen.setLineDash([])

    this.pen.lineWidth = 1.5
    this.pen.strokeStyle = this.colors.line
    this.pen.stroke(sheet)
  }

  resize() {
    const canvas = this.canvasTarget
    const ratio = window.devicePixelRatio

    canvas.style.height = "0"
    this.width = canvas.clientWidth
    this.height = document.documentElement.scrollHeight
    canvas.style.height = `${this.height}px`
    canvas.width = this.width * ratio
    canvas.height = this.height * ratio

    this.pen.scale(ratio, ratio)
    this.pen.lineJoin = "round"
  }
}

function random(min, max) {
  return min + Math.random() * (max - min)
}
