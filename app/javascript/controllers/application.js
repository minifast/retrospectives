import { Application } from "@hotwired/stimulus"
import Reveal from 'stimulus-reveal-controller'
import Notification from 'stimulus-notification'
import RailsNestedForm from 'stimulus-rails-nested-form'

const application = Application.start()
application.register('reveal', Reveal)
application.register('notification', Notification)
application.register('nested-form', RailsNestedForm)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
