import { Controller } from "@hotwired/stimulus"

const WELCOME_MESSAGES = ["What do you want?", "Can't you see I'm busy?", "I'm on a break, come back later."]

const RESPONSES = [
  "THIS IS NOT INFORMATION! 🙅‍♀️",
  "That's not my department.",
  "Let me ask my colleague.",
  "The system is down, nothing I can do.",
  "What are you doing here? I did't called you!",
]

export default class extends Controller {
  static targets = ["widget", "messages", "input", "sendButton"]

  connect() {
    this.isOpen = false
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
      setTimeout(() => this.addBotResponse(), 500)
    }
  }

  addWelcomeMessage() {
    this.addBotMessage(WELCOME_MESSAGES[Math.floor(Math.random() * WELCOME_MESSAGES.length)])
  }

  addUserMessage(message) {
    const messageDiv = document.createElement("div")
    messageDiv.className = "flex justify-end mb-3"
    messageDiv.innerHTML = `
      <div class="bg-banitsa-200 text-gray-800 px-4 py-2 rounded-lg max-w-xs">
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
            бI
          </div>
          <span class="text-xs font-semibold">бAI Ivan</span>
        </div>
        ${message}
      </div>
    `
    this.messagesTarget.appendChild(messageDiv)
    this.scrollToBottom()
  }

  addBotResponse() {
    this.addBotMessage(RESPONSES[Math.floor(Math.random() * RESPONSES.length)])
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
