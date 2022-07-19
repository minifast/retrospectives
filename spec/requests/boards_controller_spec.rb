require 'rails_helper'

RSpec.describe '/boards', type: :request do
  let(:valid_attributes) {
    {name: "Today's Retro"}
  }

  let(:invalid_attributes) {
    {name: ''}
  }

  let(:user) { create(:user) }

  describe 'GET /index' do
    before { sign_in user }

    it 'renders a successful response' do
      Board.create! valid_attributes
      get boards_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    before { sign_in user }

    it 'renders a successful response' do
      board = Board.create! valid_attributes
      get board_url(board)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    before { sign_in user }

    it 'renders a successful response' do
      get new_board_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    before { sign_in user }

    it 'renders a successful response' do
      board = Board.create! valid_attributes
      get edit_board_url(board)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    before { sign_in user }

    context 'with valid parameters' do
      it 'creates a new Board' do
        expect {
          post boards_url, params: {board: valid_attributes}
        }.to change(Board, :count).by(1)
      end

      it 'redirects to the board list' do
        post boards_url, params: {board: valid_attributes}
        expect(response).to redirect_to(boards_url)
      end

      it 'broadcasts to the boards channel' do
        expect do
          post boards_url, params: {board: valid_attributes}
        end.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).with('boards', hash_including(action: :prepend, html: a_string_including('Today&#39;s Retro')))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Board' do
        expect {
          post boards_url, params: {board: invalid_attributes}
        }.not_to change(Board, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post boards_url, params: {board: invalid_attributes}
        expect(response).not_to be_successful
      end
    end
  end

  describe 'POST /create.turbo-stream' do
    before { sign_in user }

    context 'with valid parameters' do
      it 'creates a new Board' do
        expect {
          post boards_url, params: {board: valid_attributes}, headers: {Accept: Mime['turbo_stream'].to_s}
        }.to change(Board, :count).by(1)
      end

      it 'purges the slideover' do
        post boards_url, params: {board: valid_attributes}, headers: {Accept: Mime['turbo_stream'].to_s}
        expect(page.css('turbo-stream[target=slideover] turbo-frame#slideover').children).to be_empty
      end

      it 'displays a flash message' do
        post boards_url, params: {board: valid_attributes}, headers: {Accept: Mime['turbo_stream'].to_s}
        expect(page.css('turbo-stream[target=flash] turbo-frame#flash')).to have_text('Board was successfully created')
      end
    end
  end

  describe 'PATCH /update' do
    before { sign_in user }

    context 'with valid parameters' do
      let(:new_attributes) {
        {name: "Tomorrow's Retro"}
      }

      it 'updates the requested board' do
        board = Board.create! valid_attributes
        patch board_url(board), params: {board: new_attributes}
        board.reload
        expect(board.attributes.symbolize_keys).to include(name: "Tomorrow's Retro")
      end

      it 'redirects to the board' do
        board = Board.create! valid_attributes
        patch board_url(board), params: {board: new_attributes}
        board.reload
        expect(response).to redirect_to(board_url(board))
      end

      it 'broadcasts to the boards channel' do
        expect do
          post boards_url, params: {board: valid_attributes}
        end.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).with { |name, args|
        }
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        board = Board.create! valid_attributes
        patch board_url(board), params: {board: invalid_attributes}
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PATCH /update.turbo-stream' do
    before { sign_in user }

    context 'with valid parameters' do
      let(:new_attributes) {
        {name: "Tomorrow's Retro"}
      }

      let(:board) { Board.create! valid_attributes }

      def make_request(attributes)
        patch board_url(board), params: {board: attributes}, headers: {Accept: Mime['turbo_stream'].to_s}
      end

      it 'updates the requested board' do
        make_request(new_attributes)
        board.reload
        expect(board.attributes.symbolize_keys).to include(name: "Tomorrow's Retro")
      end

      it 'broadcasts to replace a board on the boards channel' do
        expect { make_request(new_attributes) }.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).once.with(
          board.to_gid_param,
          hash_including(action: :replace, html: a_string_including('Tomorrow&#39;s Retro'), target: board)
        )
      end

      it 'broadcasts to replace a board on its header channel' do
        expect { make_request(new_attributes) }.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).once.with(
          board.to_gid_param,
          hash_including(action: :replace, html: a_string_including('Tomorrow&#39;s Retro'), target: dom_id(board, 'header'))
        )
      end
    end
  end

  describe 'DELETE /destroy' do
    before { sign_in user }

    it 'destroys the requested board' do
      board = Board.create! valid_attributes
      expect {
        delete board_url(board)
      }.to change(Board, :count).by(-1)
    end

    it 'redirects to the boards list' do
      board = Board.create! valid_attributes
      delete board_url(board)
      expect(response).to redirect_to(boards_url)
    end
  end
end
