import { Application } from '@hotwired/stimulus'
import Reveal from 'stimulus-reveal-controller'
import Notification from 'stimulus-notification'
import RailsNestedForm from 'stimulus-rails-nested-form'
import Dropdown from 'stimulus-dropdown'
import Clipboard from 'stimulus-clipboard'

const application = Application.start()
application.register('reveal', Reveal)
application.register('notification', Notification)
application.register('nested-form', RailsNestedForm)
application.register('dropdown', Dropdown)
application.register('clipboard', Clipboard)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
