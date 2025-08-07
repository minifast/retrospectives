# frozen_string_literal: true

require "rails_helper"

RSpec.describe Confetti::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new) }

  it { is_expected.to have_css('canvas[data-action="timer:end@window->confetti#fire"]') }
end
