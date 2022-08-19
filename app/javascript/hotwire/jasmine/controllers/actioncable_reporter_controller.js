import { Controller } from '@hotwired/stimulus'
import { createConsumer } from '@rails/actioncable'
const consumer = createConsumer()

export default class extends Controller {
  connect() {
    this.channel = consumer.subscriptions.create({channel: 'Hotwire::Jasmine::SuitesChannel'})
  }

  disconnect() {
    this.channel.disconnect()
  }

  post({type, detail}) {
    this.channel.perform(type.replaceAll(':', '_'), detail)
  }
}
