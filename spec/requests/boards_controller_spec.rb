require 'rails_helper'

RSpec.describe BoardsController, type: :request do
  let(:user){ FactoryBot.create(:user) }

  describe 'GET #index' do
    def make_request
      get boards_path
    end

    before do
      sign_in user
      FactoryBot.create(:board, name: "Today's Retro")
    end

    it 'renders a successful response' do
      make_request
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    def make_request(id)
      get board_path(id)
    end

    let(:board) { FactoryBot.create(:board, name: "Today's Retro") }

    before { sign_in user }

    it 'renders a successful response' do
      make_request(board.id)
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    def make_request
      get new_board_path
    end

    before { sign_in user }

    it 'renders a successful response' do
      make_request
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    def make_request(id)
      get edit_board_path(id)
    end

    let(:board) { FactoryBot.create(:board, name: "Today's Retro") }

    before { sign_in user }

    it 'renders a successful response' do
      make_request(board.id)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    def make_request(params = {})
      post boards_path, params: {board: params}
    end

    before { sign_in user }

    context 'with valid parameters' do
      it 'creates a new Board' do
        expect {
          make_request({name: "Today's Retro"})
        }.to change(Board, :count).by(1)
      end

      it 'redirects to the created board' do
        make_request({name: "Tomorrow's Retro"})
        expect(response).to redirect_to(board_path(Board.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Board' do
        expect {
          make_request({name: ''})
        }.to change(Board, :count).by(0)
      end

      it 'renders a successful response' do
        make_request({name: ''})
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PATCH #update' do
    def make_request(id, params = {})
      patch board_path(id), params: {board: params}
    end

    let(:board) { FactoryBot.create(:board, name: "Today's Retro") }

    before { sign_in user }

    context 'with valid parameters' do
      it 'updates the requested board' do
        make_request(board.id, {name: "Tomorrow's Retro"} )
        expect(board.reload.attributes.symbolize_keys).to include(name: "Tomorrow's Retro")
      end

      it 'redirects to the board' do
        make_request(board.id, {name: "Tomorrow's Retro"} )
        expect(response).to redirect_to(board_path(board.id))
      end
    end

    context 'with invalid parameters' do
      it 'renders a successful response' do
        make_request(board.id, {name: ''} )
        expect(response).not_to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    def make_request(id)
      delete board_path(id)
    end

    let!(:board) { FactoryBot.create(:board, name: "Today's Retro") }

    before { sign_in user }

    it 'destroys the requested board' do
      expect {
        make_request(board.id)
      }.to change(Board, :count).by(-1)
    end

    it 'redirects to the boards list' do
      make_request(board.id)
      expect(response).to redirect_to(boards_url)
    end
  end
end
