require 'rails_helper'

RSpec.describe TimerPolicy, type: :policy do
  subject(:policy) { described_class }

  let!(:user) { create(:user) }
  let(:board) { create(:board) }
  let!(:timer) { create(:timer, board: board) }

  describe TimerPolicy::Scope do
    subject(:scope) { described_class.new(user, Timer).resolve }

    context 'when the user is not associated with the board the timer is on' do
      it { is_expected.not_to include(timer) }
    end

    context 'when the user is associated with the board the timer is on' do
      before { create(:board_user, board: board, user: user) }

      it { is_expected.to include(timer) }
    end
  end

  permissions :show? do
    context 'when the user is not associated with the board the timer is on' do
      it { is_expected.not_to permit(user, timer) }
    end

    context 'when the user is associated with the board the timer is on' do
      before { create(:board_user, board: board, user: user) }

      it { is_expected.to permit(user, timer) }
    end
  end

  permissions :index?, :new?, :create? do
    it { is_expected.to permit(user, timer) }

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      it { is_expected.not_to permit(user, timer) }
    end
  end

  permissions :edit?, :update?, :destroy? do
    context 'when the user is not associated with the board the timer is on' do
      it { is_expected.not_to permit(user, timer) }
    end

    context 'when the user is associated with the board the timer is on' do
      before { create(:board_user, board: board, user: user) }

      it { is_expected.to permit(user, timer) }
    end

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      before { create(:board_user, board: board, user: user) }

      it { is_expected.not_to permit(user, timer) }
    end
  end
end
