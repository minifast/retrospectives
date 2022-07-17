# frozen_string_literal: true

require "rails_helper"

RSpec.describe Hero::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new) }

  it { is_expected.to have_content('Retro') }
end
