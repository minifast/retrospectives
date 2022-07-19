# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(board: board)) }

  let(:board) { create(:board, name: 'Shortboard') }

  it { is_expected.to have_content('Shortboard').and have_text(I18n.l(Time.current.utc.to_date, format: :long)) }
end
