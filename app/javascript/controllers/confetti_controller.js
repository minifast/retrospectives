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
  },
  {
    origin: { y: 0.7 },
    particleCount: 50,
    spread: 120,
    startVelocity: 75,
  },
  {
    origin: { y: 0.7 },
    particleCount: 30,
    spread: 120,
    startVelocity: 55,
    scalar: 1.2
  },
  {
    origin: { y: 0.7 },
    particleCount: 20,
    spread: 90,
    decay: 0.90,
    scalar: 1.5,
    startVelocity: 50
  },
  {
    origin: { y: 0.7 },
    particleCount: 20,
    spread: 90,
    decay: 0.90,
    scalar: 2.5,
    startVelocity: 80
  },
  {
    origin: { y: 0.7 },
    particleCount: 10,
    spread: 180,
    decay: 0.90,
    scalar: 5,
    startVelocity: 110
  },
  {
    origin: { y: 0.7 },
    particleCount: 5,
    spread: 180,
    decay: 0.90,
    scalar: 10,
    startVelocity: 120
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
