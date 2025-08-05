import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["widget", "messages", "input", "sendButton"]

  connect() {
    this.isOpen = false
    this.welcomeMessages = ["What do you want?"]
    this.responses = ["THIS IS NOT INFORMATION! 🙅‍♀️"]

    this.addWelcomeMessage()
  }

  toggle() {
    this.isOpen = !this.isOpen
    if (this.isOpen) {
      this.widgetTarget.classList.remove("translate-y-full", "opacity-0")
      this.widgetTarget.classList.add("translate-y-0", "opacity-100")
    } else {
      this.widgetTarget.classList.remove("translate-y-0", "opacity-100")
      this.widgetTarget.classList.add("translate-y-full", "opacity-0")
    }
  }

  sendMessage(event) {
    event.preventDefault()
    const message = this.inputTarget.value.trim()

    if (message) {
      this.addUserMessage(message)
      this.inputTarget.value = ""

      setTimeout(() => {
        this.addBotResponse()
      }, 500)
    }
  }

  addWelcomeMessage() {
    const welcomeMessage = this.welcomeMessages[Math.floor(Math.random() * this.welcomeMessages.length)]
    this.addBotMessage(welcomeMessage)
  }

  addUserMessage(message) {
    const messageDiv = document.createElement("div")
    messageDiv.className = "flex justify-end mb-3"
    messageDiv.innerHTML = `
      <div class="bg-blue-500 text-white px-4 py-2 rounded-lg max-w-xs">
        ${message}
      </div>
    `
    this.messagesTarget.appendChild(messageDiv)
    this.scrollToBottom()
  }

  addBotMessage(message) {
    const messageDiv = document.createElement("div")
    messageDiv.className = "flex justify-start mb-3"
    messageDiv.innerHTML = `
      <div class="bg-gray-200 text-gray-800 px-4 py-2 rounded-lg max-w-xs">
        <div class="flex items-center mb-1">
          <div class="w-6 h-6 bg-red-500 rounded-full flex items-center justify-center text-white text-xs font-bold mr-2">
            BS
          </div>
          <span class="text-xs font-semibold">Balkan Support</span>
        </div>
        ${message}
      </div>
    `
    this.messagesTarget.appendChild(messageDiv)
    this.scrollToBottom()
  }

  addBotResponse() {
    const response = this.responses[Math.floor(Math.random() * this.responses.length)]
    this.addBotMessage(response)
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
