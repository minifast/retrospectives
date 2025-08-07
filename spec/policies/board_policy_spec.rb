require "rails_helper"

RSpec.describe BoardPolicy, type: :policy do
  subject(:policy) { described_class }

  let!(:user) { create(:user) }
  let!(:board) { create(:board) }

  describe BoardPolicy::Scope do
    subject(:scope) { described_class.new(user, Board).resolve }

    context "when the user is not associated with the board" do
      it { is_expected.not_to include(board) }
    end

    context "when the user is associated with the board" do
      before { create(:board_user, board: board, user: user) }

      it { is_expected.to include(board) }
    end
  end

  permissions :show? do
    context "when the user is not associated with the board" do
      it { is_expected.not_to permit(user, board) }
    end

    context "when the user is associated with the board" do
      before { create(:board_user, board: board, user: user) }

      it { is_expected.to permit(user, board) }
    end
  end

  permissions :index?, :new?, :create? do
    it { is_expected.to permit(user, board) }

    context "when the user is a guest" do
      let(:user) { create(:user, :guest) }

      it { is_expected.not_to permit(user, board) }
    end
  end

  permissions :edit?, :update?, :destroy? do
    context "when the user is not associated with the board" do
      it { is_expected.not_to permit(user, board) }
    end

    context "when the user is associated with the board" do
      before { create(:board_user, board: board, user: user) }

      it { is_expected.to permit(user, board) }
    end

    context "when the user is a guest" do
      let(:user) { create(:user, :guest) }

      before { create(:board_user, board: board, user: user) }

      it { is_expected.not_to permit(user, board) }
    end
  end
end
