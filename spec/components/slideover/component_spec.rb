# frozen_string_literal: true

require "rails_helper"

RSpec.describe Slideover::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new) { "Make a Retro" } }

  it { is_expected.to have_content("Make a Retro") }
end
