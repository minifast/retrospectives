import { Application } from "@hotwired/stimulus"
import Reveal from 'stimulus-reveal-controller'
import Notification from 'stimulus-notification'

const application = Application.start()
application.register('reveal', Reveal)
application.register('notification', Notification)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
