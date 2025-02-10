import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="markdown-preview"
export default class extends Controller {
  static targets = ["source", "preview"]

  connect() {
    this.#preview()
    this.sourceTarget.addEventListener("blur", this.#preview)
  }

  disconnect() {
    this.sourceTarget.removeEventListener("blur", this.#preview)
  }

  #preview = async () => {
    const markdown = this.sourceTarget.value || "Nothing to preview..."
    const response = await fetch("/admin/markdown_previews", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ markdown })
    })
    const {html} = await response.json()

    this.previewTarget.innerHTML = html
  }
}

