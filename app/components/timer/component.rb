# frozen_string_literal: true

class Timer::Component < ApplicationComponent
  attr_reader :timer

  def initialize(timer:)
    @timer = timer
  end

  def time_remaining
    if duration_parts.length <= 1
      ['0', duration_parts].join(':')
    elsif duration_parts.last < 10
      (duration_parts[0..-2] + ['%02d' % duration_parts.last]).join(':')
    else
      duration_parts.join(':')
    end
  end

  private

  def duration_parts
    ActiveSupport::Duration.build(timer.duration)
      .parts
      .reverse_merge(days: 0, hours: 0, minutes: 0, seconds: 0)
      .values_at(:days, :hours, :minutes, :seconds)
      .drop_while(&:zero?)
  end
end
