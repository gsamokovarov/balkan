import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="communication-preview"
export default class extends Controller {
  static targets = ["subject", "content", "preview"]
  static values = { eventId: String }

  connect() {
    this.#preview()
    this.subjectTarget.addEventListener("blur", this.#preview)
    this.contentTarget.addEventListener("blur", this.#preview)
  }

  disconnect() {
    this.subjectTarget.removeEventListener("blur", this.#preview)
    this.contentTarget.removeEventListener("blur", this.#preview)
  }

  #preview = async () => {
    const response = await fetch(`/admin/events/${this.eventIdValue}/communication_drafts/preview`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ subject: this.subjectTarget.value, content: this.contentTarget.value }),
    })

    const { subject, body } = await response.json()

    this.previewTarget.innerHTML = `
      <h3 class="mb-2">${subject || "No subject"}</h3>
      <p>${body}</p>
    `
  }
}
