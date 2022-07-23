import Timeago from 'stimulus-timeago'

const formatDistanceToNow = (date) => {
  let days = Math.floor(date / (1000 * 60 * 60 * 24))
  let hours = Math.floor((date / (1000 * 60 * 60)) % 24)
  let minutes = Math.floor((date / 1000 / 60) % 60)
  let seconds = Math.floor((date / 1000) % 60)
  let output = [days, hours, minutes].filter(time => time > 0)
  if (seconds > 10) {
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

    if (this.isValid) {
      this.element.innerHTML = formatDistanceToNow(date - now)
    } else {
      this.element.innerHTML = '0:00'
    }
  }
}
