require 'rails_helper'

RSpec.describe Boards::TimersController, type: :request do
  let(:board) { create(:board) }
  let(:user) { create(:user) }

  describe 'GET #show' do
    before { sign_in(user, scope: :user) }

    def make_request(board_id)
      get board_timer_url(board_id)
    end

    context 'when there is no timer' do
      it 'renders a successful response' do
        make_request(board.id)
        expect(page).to have_content('Start Timer').and have_button('5 minutes')
      end
    end

    context 'when there is a timer' do
      before { create(:timer, board: board, duration: 6.minutes) }

      it 'renders a successful response' do
        make_request(board.id)
        expect(page).to have_content('6:00').and have_button('Stop Timer')
      end
    end
  end

  describe 'POST #create' do
    before { sign_in(user, scope: :user) }

    def make_request(board_id, timer_params)
      post board_timer_url(board_id), params: {timer: timer_params}
    end

    context 'with valid parameters' do
      it 'creates a new Timer' do
        expect {
          make_request(board.id, duration: 300)
        }.to change(Timer, :count).by(1)
      end

      it 'redirects to the created timer' do
        make_request(board.id, duration: 300)
        expect(response).to redirect_to(board_timer_url(board))
      end
    end

    context 'when a timer already exists' do
      before { create(:timer, board: board) }

      it 'creates a new Timer' do
        expect {
          make_request(board.id, duration: 300)
        }.not_to change(Timer, :count)
      end

      it 'redirects to the created timer' do
        make_request(board.id, duration: 300)
        expect(response).to redirect_to(board_timer_url(board))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Timer' do
        expect {
          make_request(board.id, duration: 0)
        }.not_to change(Timer, :count)
      end

      it 'is not successful' do
        make_request(board.id, duration: 0)
        expect(response).not_to be_successful
      end
    end
  end

  describe 'POST #create.turbo_stream' do
    before { sign_in(user, scope: :user) }

    def make_request(board_id, timer_params)
      post board_timer_url(board_id), params: {timer: timer_params}, headers: {Accept: Mime['turbo_stream'].to_s}
    end

    context 'with valid parameters' do
      it 'creates a new Timer' do
        expect { make_request(board.id, duration: 300) }.to change(Timer, :count).by(1)
      end

      it 'displays a flash message' do
        make_request(board.id, duration: 300)
        expect(page.css('turbo-stream[target=flash] turbo-frame#flash')).to have_text('Timer was successfully created')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user, scope: :user) }

    def make_request(board_id)
      delete board_timer_url(board_id)
    end

    context 'with valid parameters' do
      before { create(:timer, board: board) }

      it 'destroys the requested timer' do
        expect { make_request(board.id) }.to change(Timer, :count).by(-1)
      end

      it 'redirects to the timer page' do
        make_request(board.id)
        expect(response).to redirect_to(board_timer_url(board))
      end
    end

    context 'when the timer does not exist' do
      it 'destroys the requested timer' do
        expect { make_request(board.id) }.not_to change(Timer, :count)
      end

      it 'redirects to the timer page' do
        make_request(board.id)
        expect(response).to redirect_to(board_timer_url(board))
      end
    end
  end

  describe 'DELETE #destroy.turbo_stream' do
    before { sign_in(user, scope: :user) }

    def make_request(board_id)
      delete board_timer_url(board_id), headers: {Accept: Mime['turbo_stream'].to_s}
    end

    context 'with valid parameters' do
      before { create(:timer, board: board) }

      it 'destroys the requested timer' do
        expect { make_request(board.id) }.to change(Timer, :count).by(-1)
      end

      it 'displays a flash message' do
        make_request(board.id)
        expect(page.css('turbo-stream[target=flash] turbo-frame#flash')).to have_text('Timer was successfully destroyed')
      end
    end
  end
end
