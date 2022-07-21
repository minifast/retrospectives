import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    const time = this.element.getAttribute('datetime')
    const parsed = new Date(time)
    const dateFormat = new Intl.DateTimeFormat('en', {dateStyle: 'long'})
    const timeFormat = new Intl.DateTimeFormat('en', {timeStyle: 'short'})
    this.element.innerText = `${dateFormat.format(parsed)} ${timeFormat.format(parsed)}`
  }
}
