import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="communication-preview"
export default class extends Controller {
  static targets = ["subject", "content", "preview", "eventId"]

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
    const formData = new FormData()
    const subject = this.subjectTarget.value || ""
    const content = this.contentTarget.value || ""

    formData.append("subject", subject)
    formData.append("content", content)

    if (this.hasEventIdTarget && this.eventIdTarget.value) {
      formData.append("event_id", this.eventIdTarget.value)
    }

    const response = await fetch("/admin/communication_drafts/preview", {
      method: "POST",
      headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content },
      body: formData,
    })

    const { subject: renderedSubject, body: renderedBody } = await response.json()

    this.previewTarget.innerHTML = `
      <div class="mb-4">
        <h4 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Subject</h4>
        <p class="text-base font-semibold text-gray-900 dark:text-gray-100">${renderedSubject || "—"}</p>
      </div>
      <div>
        <h4 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Body</h4>
        <div class="prose p-4 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 max-h-96 overflow-y-auto">
          ${renderedBody || "—"}
        </div>
      </div>
    `
  }
}
