require 'rails_helper'

RSpec.describe TopicPolicy, type: :policy do
  subject(:policy) { described_class }

  let!(:user) { create(:user) }
  let(:board) { create(:board) }
  let(:column) { create(:column, board: board) }
  let!(:topic) { create(:topic, column: column) }

  describe TopicPolicy::Scope do
    subject(:scope) { described_class.new(user, Topic).resolve }

    context 'when the user is not associated with the board' do
      it { is_expected.not_to include(topic) }
    end

    context 'when the user is associated with the board' do
      before { create(:board_user, board: board, user: user) }

      it { is_expected.to include(topic) }
    end
  end

  permissions :show? do
    context 'when the user is not associated with the board' do
      it { is_expected.not_to permit(user, topic) }
    end

    context 'when the user is associated with the board' do
      before { create(:board_user, board: board, user: user) }

      it { is_expected.to permit(user, topic) }
    end
  end

  permissions :index?, :new?, :create? do
    it { is_expected.to permit(user, topic) }

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      it { is_expected.to permit(user, topic) }
    end
  end

  permissions :edit?, :update?, :destroy? do
    context 'when the user is not associated with the board' do
      it { is_expected.not_to permit(user, topic) }
    end

    context 'when the user is associated with the board' do
      before { create(:board_user, board: board, user: user) }

      it { is_expected.not_to permit(user, topic) }

      context 'when the user created the topic' do
        let!(:topic) { create(:topic, column: column, user: user) }

        it { is_expected.to permit(user, topic) }
      end
    end

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      before { create(:board_user, board: board, user: user) }

      it { is_expected.not_to permit(user, topic) }

      context 'when the guest created the topic' do
        let!(:topic) { create(:topic, column: column, user: user) }

        it { is_expected.to permit(user, topic) }
      end
    end
  end
end
