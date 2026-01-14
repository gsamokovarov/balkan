import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invoice-preview"
export default class extends Controller {
  static targets = ["form", "preview"]

  connect() {
    this.#preview()
    this.formTarget.addEventListener("blur", this.#preview, true)
  }

  disconnect() {
    this.formTarget.removeEventListener("blur", this.#preview, true)
  }

  #preview = async () => {
    const formData = new FormData(this.formTarget)

    const response = await fetch("/admin/invoices/preview", {
      method: "POST",
      headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content },
      body: formData,
    })

    if (!response.ok) return

    const blob = await response.blob()
    const url = URL.createObjectURL(blob)

    this.previewTarget.src = url
  }
}
