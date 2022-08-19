import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  receive({data: {type, detail}}) {
    const event = new CustomEvent(type, {detail, bubbles: true})
    this.element.dispatchEvent(event)
  }
}
