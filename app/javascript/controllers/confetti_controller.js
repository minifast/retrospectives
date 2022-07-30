import { Controller } from '@hotwired/stimulus'
import confetti from 'canvas-confetti'

const REALISTIC_CONFETTI = [
  {
    origin: { y: 0.7 },
    particleCount: 25,
    spread: 26,
    startVelocity: 55,
  },
  {
    origin: { y: 0.7 },
    particleCount: 20,
    spread: 60,
  },
  {
    origin: { y: 0.7 },
    particleCount: 35,
    spread: 100,
    decay: 0.91,
    scalar: 0.8
  },
  {
    origin: { y: 0.7 },
    particleCount: 10,
    spread: 120,
    startVelocity: 25,
    decay: 0.92,
    scalar: 1.2
  },
  {
    origin: { y: 0.7 },
    particleCount: 10,
    spread: 120,
    startVelocity: 45,
  }
]

export default class extends Controller {
  connect() {
    this.confetti = confetti.create(this.element, {resize: true})
  }

  disconnect() {
    this.confetti = null
  }

  fire() {
    REALISTIC_CONFETTI.forEach(this.confetti)
  }
}
