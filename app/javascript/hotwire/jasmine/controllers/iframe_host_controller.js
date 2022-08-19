import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  post(event) {
    const {type, detail} = event
    window.parent.postMessage({type, detail}, "*")
  }
}
