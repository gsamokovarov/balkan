import { Controller } from "@hotwired/stimulus"

const INLINE_IMAGE_PLACEHOLDER = /\[(\d+)\]/g

// Connects to data-controller="markdown-preview"
export default class extends Controller {
  static targets = ["content", "preview", "images"]

  connect() {
    this.#preview()
    this.contentTarget.addEventListener("blur", this.#preview)
  }

  disconnect() {
    this.contentTarget.removeEventListener("blur", this.#preview)
  }

  #preview = async () => {
    const formData = new FormData()
    const content = this.contentTarget.value || "Nothing to preview..."
    formData.append("content", content)
    const response = await fetch("/admin/markdown_previews", {
      method: "POST",
      headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content },
      body: formData,
    })
    let { html } = await response.json()

    html = this.#replaceImagePlaceholders(html)

    this.previewTarget.innerHTML = html
  }

  #replaceImagePlaceholders(html) {
    const files = this.imagesTarget.files || []
    const existingImages = this.imagesTarget.parentElement.querySelectorAll("img")

    if (files.length === 0 && existingImages.length === 0) return html

    const imageUrls = {}

    if (files.length > 0) {
      for (let i = 0; i < files.length; i++) {
        if (files[i].type.startsWith("image/")) {
          imageUrls[i + 1] = URL.createObjectURL(files[i])
        }
      }
    } else if (existingImages.length > 0) {
      existingImages.forEach((img, i) => {
        imageUrls[i + 1] = img.src
      })
    }

    return html.replaceAll(INLINE_IMAGE_PLACEHOLDER, (match, index) => {
      if (imageUrls[index]) {
        return `<img src="${imageUrls[index]}" alt="Image ${index}">`
      }
      return match
    })
  }
}
