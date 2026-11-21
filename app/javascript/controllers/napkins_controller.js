import { Controller } from "@hotwired/stimulus"

const GRAVITY = 520
const MAX_FRAME_SECONDS = 0.05

// Connects to data-controller="napkins"
export default class extends Controller {
  static targets = ["canvas", "thrower"]
  static values = { count: { type: Number, default: 70 } }

  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return

    this.napkins = []
    this.canvasContext = this.canvasTarget.getContext("2d")
    this.colors = this.readColors()

    this.resize = this.resize.bind(this)
    this.tick = this.tick.bind(this)

    this.observer = new ResizeObserver(this.resize)
    this.observer.observe(this.element)
    window.addEventListener("resize", this.resize)
    this.resize()

    this.throwerTargets.forEach((thrower) => { thrower.hidden = false })
    this.rain()
  }

  disconnect() {
    this.observer?.disconnect()
    window.removeEventListener("resize", this.resize)
    cancelAnimationFrame(this.frame)
    this.frame = null
    this.napkins = []
  }

  rain() {
    const count = Math.round(this.countValue * Math.min(1, Math.max(0.45, this.width / 1200)))

    for (let index = 0; index < count; index++) {
      this.napkins.push(this.build({
        x: random(0, this.width),
        y: -random(40, window.innerHeight * 1.6),
        vx: random(-30, 30),
        vy: random(60, 140),
      }))
    }

    this.start()
  }

  throw(event) {
    if (!this.canvasContext) return

    const origin = event.currentTarget.getBoundingClientRect()
    const page = this.canvasTarget.getBoundingClientRect()

    for (let index = 0; index < 16; index++) {
      this.napkins.push(this.build({
        x: origin.left - page.left + origin.width / 2 + random(-20, 20),
        y: origin.top - page.top,
        vx: random(-520, 520),
        vy: -random(900, 1900),
      }))
    }

    this.start()
  }

  build(attributes) {
    return {
      size: random(30, 54),
      terminal: random(90, 150),
      rx: random(0, Math.PI * 2),
      ry: random(0, Math.PI * 2),
      rz: random(0, Math.PI * 2),
      wx: random(1.2, 3.4) * randomSign(),
      wy: random(0.6, 2.2) * randomSign(),
      wz: random(0.2, 1) * randomSign(),
      sway: random(25, 80),
      swayPhase: random(0, Math.PI * 2),
      swaySpeed: random(1, 2.4),
      ...attributes,
    }
  }

  start() {
    if (this.frame) return

    this.previous = performance.now()
    this.frame = requestAnimationFrame(this.tick)
  }

  tick(now) {
    const seconds = Math.min((now - this.previous) / 1000, MAX_FRAME_SECONDS)
    this.previous = now

    this.napkins = this.napkins.filter((napkin) => {
      this.move(napkin, seconds)

      return napkin.y < this.height + napkin.size * 2
    })

    this.canvasContext.clearRect(0, 0, this.width, this.height)
    this.napkins.forEach((napkin) => this.draw(napkin))

    this.frame = this.napkins.length > 0 ? requestAnimationFrame(this.tick) : null
  }

  move(napkin, seconds) {
    const terminal = napkin.terminal * (0.65 + 0.7 * Math.abs(Math.sin(napkin.rx)))
    const drag = GRAVITY / terminal

    napkin.swayPhase += napkin.swaySpeed * seconds
    napkin.vy += (GRAVITY - drag * napkin.vy) * seconds
    napkin.vx += (napkin.sway * Math.cos(napkin.swayPhase) - napkin.vx) * 2.2 * seconds

    napkin.x += napkin.vx * seconds
    napkin.y += napkin.vy * seconds
    napkin.rx += napkin.wx * seconds
    napkin.ry += napkin.wy * seconds
    napkin.rz += napkin.wz * seconds
  }

  draw(napkin) {
    const context = this.canvasContext
    const half = napkin.size / 2
    const facing = Math.cos(napkin.rx) * Math.cos(napkin.ry)
    const project = (u, v) => projectPoint(napkin, u * half, v * half)

    trace(context, [project(-1, -1), project(1, -1), project(1, 1), project(-1, 1)])
    context.fillStyle = facing > 0 ? this.colors.front : this.colors.back
    context.fill()
    context.fillStyle = `rgba(0, 0, 0, ${(1 - Math.abs(facing)) * 0.1})`
    context.fill()

    context.beginPath()
    line(context, project(0, -1), project(0, 1))
    line(context, project(-1, 0), project(1, 0))
    context.lineWidth = 1
    context.strokeStyle = this.colors.crease
    context.stroke()

    trace(context, [project(-0.72, -0.72), project(0.72, -0.72), project(0.72, 0.72), project(-0.72, 0.72)])
    context.setLineDash([2, 3])
    context.strokeStyle = this.colors.emboss
    context.stroke()
    context.setLineDash([])

    trace(context, [project(-1, -1), project(1, -1), project(1, 1), project(-1, 1)])
    context.lineWidth = 1.5
    context.lineJoin = "round"
    context.strokeStyle = this.colors.line
    context.stroke()
  }

  resize() {
    const ratio = window.devicePixelRatio || 1

    this.canvasTarget.style.height = "0"
    this.width = document.documentElement.clientWidth
    this.height = document.documentElement.scrollHeight
    this.canvasTarget.style.width = `${this.width}px`
    this.canvasTarget.style.height = `${this.height}px`
    this.canvasTarget.width = this.width * ratio
    this.canvasTarget.height = this.height * ratio
    this.canvasContext.setTransform(ratio, 0, 0, ratio, 0, 0)
  }

  readColors() {
    const style = getComputedStyle(this.element)
    const color = (name, fallback) => style.getPropertyValue(name).trim() || fallback

    return {
      front: color("--brand-card", "#fff"),
      back: color("--brand-100", "#fce9eb"),
      crease: color("--brand-200", "#f8ced3"),
      emboss: color("--brand-300", "#f2abb2"),
      line: color("--brand-line", "#000"),
    }
  }
}

function projectPoint(napkin, u, v) {
  const y = v * Math.cos(napkin.rx)
  const depth = v * Math.sin(napkin.rx)
  const x = u * Math.cos(napkin.ry) + depth * Math.sin(napkin.ry)
  const cos = Math.cos(napkin.rz)
  const sin = Math.sin(napkin.rz)

  return [napkin.x + x * cos - y * sin, napkin.y + x * sin + y * cos]
}

function trace(context, points) {
  context.beginPath()
  points.forEach(([x, y], index) => (index === 0 ? context.moveTo(x, y) : context.lineTo(x, y)))
  context.closePath()
}

function line(context, [fromX, fromY], [toX, toY]) {
  context.moveTo(fromX, fromY)
  context.lineTo(toX, toY)
}

function random(min, max) {
  return min + Math.random() * (max - min)
}

function randomSign() {
  return Math.random() < 0.5 ? -1 : 1
}
