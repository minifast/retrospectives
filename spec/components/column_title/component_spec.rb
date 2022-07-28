# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ColumnTitle::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(column: column)) }

  let(:column) { create(:column, name: 'Ionian') }

  it { is_expected.to have_content('Ionian') }
end
