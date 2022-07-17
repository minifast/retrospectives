# frozen_string_literal: true

require "rails_helper"

RSpec.describe Footer::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new) }

  it { is_expected.to have_content('Ministry of Velocity').and have_content('Github').and have_content('Twitter') }
end
