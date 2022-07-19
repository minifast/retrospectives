# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardForm::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(board: board)) }

  let(:board) { Board.new }

  it { is_expected.to have_field('Name') }

  context 'when there are errors' do
    before { board.valid? }

    it { is_expected.to have_text("Name can't be blank") }
  end
end
