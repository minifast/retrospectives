# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Timer::Component, type: :component do
  subject(:rendered) { render_inline(described_class.new(timer: timer)) }

  let(:board) { create(:board) }
  let(:timer) { build(:timer, board: board) }

  context 'when there is no timer' do
    it { is_expected.to have_content('Timer').and have_button('Start 5 minutes') }
  end

  context 'when there is a timer' do
    let(:timer) { create(:timer, board: board, duration: 5.minutes) }

    it { is_expected.to have_content('5:00').and have_button('Stop Timer') }
  end

  context 'when there is a timer with less than a minute' do
    let(:timer) { create(:timer, board: board, duration: 42.seconds) }

    it { is_expected.to have_content('0:42').and have_button('Stop Timer') }
  end

  context 'when there is a timer with just over a minute' do
    let(:timer) { create(:timer, board: board, duration: 61.seconds) }

    it { is_expected.to have_content('1:01').and have_button('Stop Timer') }
  end
end
