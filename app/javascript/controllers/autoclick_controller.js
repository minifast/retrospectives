import { Controller } from '@hotwired/stimulus'
import { useIntersection } from 'stimulus-use'

export default class extends Controller {
  options = {threshold: 0}

  connect() {
    useIntersection(this, this.options)
  }

  appear(entry) {
    this.element.click()
  }
}
