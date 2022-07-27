require 'rails_helper'

RSpec.describe Boards::SharesController, type: :request do
  describe 'GET #show' do
    let(:board) { create(:board) }

    def make_request(board_id, token)
      get board_share_path(board_id, token)
    end

    context 'when not logged in' do
      it 'renders a successful response' do
        make_request(board.id, board.share_token)
        expect(response).to redirect_to(board_path(board))
      end

      it 'creates a new user' do
        expect { make_request(board.id, board.share_token) }.to change(User, :count).by(1)
      end

      it 'creates a new board user association' do
        expect { make_request(board.id, board.share_token) }.to change(BoardUser, :count).by(1)
      end

      it 'broadcasts to replace a board on its header channel' do
        expect { make_request(board.id, board.share_token) }
          .to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).once
          .with(board.to_gid_param, hash_including(action: :replace, html: a_string_including('Testing Guest'), target: dom_id(board, :users)))
      end
    end

    context 'when logged in' do
      let(:user) { create(:user, name: 'Pleasant Participant') }

      before { sign_in(user, scope: :user) }

      it 'renders a successful response' do
        make_request(board.id, board.share_token)
        expect(response).to redirect_to(board_path(board))
      end

      it 'does not create a new user' do
        expect { make_request(board.id, board.share_token) }.not_to change(User, :count)
      end

      it 'creates a new board user association' do
        expect { make_request(board.id, board.share_token) }.to change(BoardUser, :count).by(1)
      end

      it 'broadcasts to replace a board on its header channel' do
        expect { make_request(board.id, board.share_token) }
          .to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).once
          .with(board.to_gid_param, hash_including(action: :replace, html: a_string_including('Pleasant Participant'), target: dom_id(board, :users)))
      end
    end

    context 'when logged in as a prior participant' do
      let(:user) { create(:user) }

      before do
        create(:board_user, user: user, board: board)
        sign_in(user, scope: :user)
      end

      it 'renders a successful response' do
        make_request(board.id, board.share_token)
        expect(response).to redirect_to(board_path(board))
      end

      it 'does not create a new user' do
        expect { make_request(board.id, board.share_token) }.not_to change(User, :count)
      end

      it 'does not create a new board user association' do
        expect { make_request(board.id, board.share_token) }.not_to change(BoardUser, :count)
      end
    end

    context 'with an invalid share token' do
      it 'redirects to the root path' do
        make_request(board.id, 'not likely')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
