# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardsList::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(boards: Board.all)) }

  context 'when there is a board' do
    before { create(:board, name: 'Longboard') }

    it { is_expected.to have_content('Longboard').and have_text(I18n.l(Time.current.utc.to_date, format: :long)) }
  end
end
