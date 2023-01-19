require 'rails_helper'

RSpec.describe Boards::TimersController do
  let(:board) { create(:board) }
  let(:user) { create(:user) }

  describe 'GET #show' do
    def make_request(board_id)
      get board_timer_url(board_id)
    end

    context 'when not logged in' do
      it 'blows up' do
        expect { make_request(board.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when logged in as a user' do
      before { sign_in(user, scope: :user) }

      it 'blows up' do
        expect { make_request(board.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when logged in as a guest' do
      let(:user) { create(:user, :guest) }

      before { sign_in(user, scope: :user) }

      it 'blows up' do
        expect { make_request(board.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is associated with a timerless board' do
      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'renders a successful response' do
        make_request(board.id)
        expect(page).to have_content('Timer').and have_button('Start 5 minutes')
      end
    end

    context 'when a guest is associated with a timerless board' do
      let(:user) { create(:user, :guest) }

      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'renders a successful response' do
        make_request(board.id)
        expect(page).to have_content('Timer').and have_button('Start 5 minutes')
      end
    end

    context 'when the user is associated with a board with a timer' do
      before do
        create(:timer, board: board, duration: 6.minutes)
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'renders a successful response' do
        make_request(board.id)
        expect(page).to have_content('6:00').and have_button('Stop Timer')
      end
    end

    context 'when a guest is associated with a board with a timer' do
      let(:user) { create(:user, :guest) }

      before do
        create(:timer, board: board, duration: 6.minutes)
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'renders a successful response' do
        make_request(board.id)
        expect(page).to have_content('6:00').and have_button('Stop Timer')
      end
    end
  end

  describe 'POST #create' do
    def make_request(board_id, timer_params)
      post board_timer_url(board_id), params: {timer: timer_params}
    end

    context 'when logged in as a user' do
      before { sign_in(user, scope: :user) }

      it 'displays a flash message' do
        make_request(board.id, duration: 300)
        expect(flash[:alert]).to eq('You are not allowed to create a timer.')
      end
    end

    context 'when logged in as a guest' do
      let(:user) { create(:user, :guest) }

      before { sign_in(user, scope: :user) }

      it 'displays a flash message' do
        make_request(board.id, duration: 300)
        expect(flash[:alert]).to eq('You are not allowed to create a timer.')
      end
    end

    context 'when the user is associated with a timerless board' do
      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'creates a new Timer' do
        expect { make_request(board.id, duration: 300) }.to change(Timer, :count).by(1)
      end

      it 'redirects to the created timer' do
        make_request(board.id, duration: 300)
        expect(response).to redirect_to(board_timer_url(board))
      end

      context 'with invalid parameters' do
        it 'does not create a new Timer' do
          expect { make_request(board.id, duration: 0) }.not_to change(Timer, :count)
        end

        it 'is not successful' do
          make_request(board.id, duration: 0)
          expect(response).not_to be_successful
        end
      end
    end

    context 'when a guest is associated with a timerless board' do
      let(:user) { create(:user, :guest) }

      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'displays a flash message' do
        make_request(board.id, duration: 300)
        expect(flash[:alert]).to eq('You are not allowed to create a timer.')
      end
    end

    context 'when the user is associated with a board with a timer' do
      before do
        create(:timer, board: board, duration: 6.minutes)
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'creates a new Timer' do
        expect { make_request(board.id, duration: 300) }.not_to change(Timer, :count)
      end

      it 'redirects to the created timer' do
        make_request(board.id, duration: 300)
        expect(response).to redirect_to(board_timer_url(board))
      end

      it 'creates a new timer with the requested duration' do
        make_request(board.id, duration: 300)
        expect(board.reload.timer.duration).to eq(300)
      end
    end
  end

  describe 'POST #create.turbo_stream' do
    before do
      create(:board_user, board: board, user: user)
      sign_in(user, scope: :user)
    end

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
    def make_request(board_id)
      delete board_timer_url(board_id)
    end

    context 'when logged in as a user' do
      before { sign_in(user, scope: :user) }

      it 'displays a flash message' do
        make_request(board.id)
        expect(flash[:alert]).to eq('You are not allowed to stop a timer.')
      end
    end

    context 'when logged in as a guest' do
      let(:user) { create(:user, :guest) }

      before { sign_in(user, scope: :user) }

      it 'displays a flash message' do
        make_request(board.id)
        expect(flash[:alert]).to eq('You are not allowed to stop a timer.')
      end
    end

    context 'when the user is associated with a board with a timer' do
      before do
        create(:timer, board: board, duration: 6.minutes)
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'destroys the requested timer' do
        expect { make_request(board.id) }.to change(Timer, :count).by(-1)
      end

      it 'redirects to the timer page' do
        make_request(board.id)
        expect(response).to redirect_to(board_timer_url(board))
      end
    end

    context 'when a guest is associated with a board with a timer' do
      let(:user) { create(:user, :guest) }

      before do
        create(:timer, board: board, duration: 6.minutes)
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'displays a flash message' do
        make_request(board.id)
        expect(flash[:alert]).to eq('You are not allowed to stop a timer.')
      end
    end

    context 'when the user is associated with a timerless board' do
      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'redirects to the timer page' do
        make_request(board.id)
        expect(response).to redirect_to(board_timer_url(board))
      end
    end
  end

  describe 'DELETE #destroy.turbo_stream' do
    before do
      create(:timer, board: board, duration: 6.minutes)
      create(:board_user, board: board, user: user)
      sign_in(user, scope: :user)
    end

    def make_request(board_id)
      delete board_timer_url(board_id), headers: {Accept: Mime['turbo_stream'].to_s}
    end

    it 'destroys the requested timer' do
      expect { make_request(board.id) }.to change(Timer, :count).by(-1)
    end

    it 'displays a flash message' do
      make_request(board.id)
      expect(page.css('turbo-stream[target=flash] turbo-frame#flash')).to have_text('Timer was successfully destroyed')
    end
  end
end
