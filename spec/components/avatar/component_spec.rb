# frozen_string_literal: true

require "rails_helper"

RSpec.describe Avatar::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(name: 'Doc', title: 'Taco Enjoyer', email: 'hi@example.com')) }

  it { is_expected.to have_content('Doc').and have_content('Taco Enjoyer') }
end
