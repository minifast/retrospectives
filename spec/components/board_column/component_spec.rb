# frozen_string_literal: true

require "rails_helper"

RSpec.describe BoardColumn::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(column: column)) }

  let(:column) { create(:column, name: "Happy") }

  it { is_expected.to have_content("Happy") }
end
