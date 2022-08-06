import Timeago from 'stimulus-timeago'

const formatDistanceToNow = (date) => {
  let days = Math.floor(date / (1000 * 60 * 60 * 24))
  let hours = Math.floor((date / (1000 * 60 * 60)) % 24)
  let minutes = Math.floor((date / 1000 / 60) % 60)
  let seconds = Math.floor((date / 1000) % 60)
  let output = [days, hours].filter(time => time > 0)
  output.push(minutes)
  if (seconds >= 10) {
    output.push(seconds)
  } else {
    output.push(`0${seconds}`)
  }
  return output.join(':')
}

export default class extends Timeago {
  connect() {
    super.connect()
  }

  load () {
    const datetime = this.datetimeValue
    const date = Date.parse(datetime)
    const now = (new Date()).getTime()
    this.isValid = !Number.isNaN(date) && date >= now

    this.element.innerHTML = formatDistanceToNow(Math.max(0, date - now))
    if (!this.isValid) {
      this.stopRefreshing()
    }
  }

  stopRefreshing () {
    if (this.refreshTimer) {
      this.element.dispatchEvent(new CustomEvent('timer:end', {bubbles: true}))
      clearInterval(this.refreshTimer)
    }
  }
}
