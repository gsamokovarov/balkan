import { Controller } from "@hotwired/stimulus"
import html2canvas from "html2canvas"

export default class extends Controller {
  static targets = ["element"]
  static values = {
    filename: { type: String, default: "screenshot.png" },
    scale: { type: Number, default: 2 },
  }

  async capture(event) {
    if (event) event.preventDefault()

    const options = {
      scale: this.scaleValue,
      logging: false,
      useCORS: true,
      allowTaint: true,
      backgroundColor: null,
    }

    const canvas = await html2canvas(this.elementTarget, options)
    const image = canvas.toDataURL("image/png")

    this.downloadImage(image)
  }

  downloadImage(dataUrl) {
    const link = document.createElement("a")
    link.href = dataUrl
    link.download = this.filenameValue

    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  }
}
