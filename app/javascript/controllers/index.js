// Import and register all your controllers from the importmap under controllers/*

import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()

// Configure Stimulus development experience
application.debug = document.head.querySelector(`meta[name="env"]`)?.content === "development"
window.Stimulus = application

// Eager load all controllers defined in the import map under controllers/**/*_controller
eagerLoadControllersFrom("controllers", application)
