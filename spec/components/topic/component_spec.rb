# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(topic: topic)) }

  let(:topic) { create(:topic, name: 'Lunch') }

  it { is_expected.to have_content('Lunch') }
end
