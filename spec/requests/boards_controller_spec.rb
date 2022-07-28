require 'rails_helper'

RSpec.describe BoardsController, type: :request do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let!(:board) { create(:board, name: 'Thursday Retro') }

    before { sign_in(user, scope: :user) }

    def make_request
      get boards_url
    end

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      it 'blows up' do
        expect { make_request }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is not a participant on the board' do
      it 'renders a successful response' do
        make_request
        expect(page).to have_no_content('Thursday Retro')
      end
    end

    context 'when the user is a participant on the board' do
      before { create(:board_user, board: board, user: user) }

      it 'renders a successful response' do
        make_request
        expect(page).to have_content('Thursday Retro')
      end
    end
  end

  describe 'GET #show' do
    let(:board) { create(:board, name: 'Thursday Retro') }

    before { sign_in(user, scope: :user) }

    def make_request(id)
      get board_url(id)
    end

    context 'when the user is not a participant on the board' do
      it 'blows up' do
        expect { make_request(board.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is a participant on the board' do
      before { create(:board_user, board: board, user: user) }

      it 'renders a successful response' do
        make_request(board.id)
        expect(page).to have_content('Thursday Retro')
      end
    end
  end

  describe 'GET #new' do
    before { sign_in(user, scope: :user) }

    def make_request
      get new_board_url
    end

    it 'renders a successful response' do
      make_request
      expect(page).to have_field('Board name').and have_button('Create Board')
        .and have_field('Column name', with: 'Happy').and have_field('Column name', with: 'Meh').and have_field('Column name', with: 'Sad')
        .and have_button('Add Column').and have_button('Remove Column')
    end

    it 'does not accidentally create a board' do
      expect do
        make_request
      end.not_to change(Board, :count)
    end

    it 'does not accidentally create a column' do
      expect do
        make_request
      end.not_to change(Column, :count)
    end

    it 'does not accidentally connect a board to a user' do
      expect do
        make_request
      end.not_to change(BoardUser, :count)
    end

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      it 'blows up' do
        expect { make_request }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'GET #edit' do
    let(:board) { create(:board, name: 'Thursday Retro') }

    before do
      create(:column, board: board, name: 'Good')
      sign_in(user, scope: :user)
    end

    def make_request(id)
      get edit_board_url(id)
    end

    context 'when the user is not a participant on the board' do
      it 'blows up' do
        expect { make_request(board.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is a participant on the board' do
      before { create(:board_user, board: board, user: user) }

      it 'renders a successful response' do
        make_request(board.id)
        expect(page).to have_field('Board name', with: 'Thursday Retro')
          .and have_field('Column name', with: 'Good')
          .and have_button('Add Column').and have_button('Remove Column')
          .and have_button('Update Board')
      end
    end

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      before { create(:board_user, board: board, user: user) }

      it 'blows up' do
        expect { make_request(board.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'POST #create' do
    before { sign_in(user, scope: :user) }

    def make_request(attributes)
      post boards_url, params: {board: attributes}
    end

    context 'with valid parameters' do
      it 'creates a new board' do
        expect do
          make_request(name: 'Thursday Retro', columns_attributes: {'0' => {name: 'Happy'}})
        end.to change(Column, :count).by(1).and change(Board, :count).by(1).and change(BoardUser, :count).by(1)
      end

      it 'redirects to the board list' do
        make_request(name: 'Thursday Retro', columns_attributes: {'0' => {name: 'Happy'}})
        expect(response).to redirect_to(boards_url)
      end

      it 'broadcasts to the boards channel' do
        expect { make_request(name: 'Thursday Retro', columns_attributes: {'0' => {name: 'Happy'}}) }
          .to have_enqueued_job(Turbo::Streams::ActionBroadcastJob)
          .with('boards', hash_including(action: :prepend, html: a_string_including('Thursday Retro')))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Board' do
        expect { make_request(name: '') }.not_to change(Board, :count)
      end

      it 'is unsuccessful' do
        make_request(name: '')
        expect(response).not_to be_successful
      end

      it 'renders an error message' do
        make_request(name: '')
        expect(page).to have_content("Board name can't be blank")
          .and have_content("Columns can't be blank")
      end
    end

    context 'with an invalid column' do
      it 'does not create a new Board' do
        expect { make_request(name: 'Charcuterie', columns_attributes: {'0' => {name: ''}}) }.not_to change(Board, :count)
      end

      it 'is unsuccessful' do
        make_request(name: 'Charcuterie', columns_attributes: {'0' => {name: ''}})
        expect(response).not_to be_successful
      end

      it 'renders an error message' do
        make_request(name: 'Charcuterie', columns_attributes: {'0' => {name: ''}})
        expect(page).to have_content("Column name can't be blank")
      end
    end

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      it 'blows up' do
        expect do
          make_request(name: 'Thursday Retro', columns_attributes: {'0' => {name: 'Happy'}})
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'POST #create.turbo_stream' do
    before { sign_in(user, scope: :user) }

    def make_request(attributes)
      post boards_url, params: {board: attributes}, headers: {Accept: Mime['turbo_stream'].to_s}
    end

    context 'with valid parameters' do
      it 'creates a new Board' do
        expect { make_request(name: 'Thursday Retro', columns_attributes: {'0' => {name: 'Happy'}}) }.to change(Board, :count).by(1)
      end

      it 'purges the slideover' do
        make_request(name: 'Thursday Retro', columns_attributes: {'0' => {name: 'Happy'}})
        expect(page.css('turbo-stream[target=slideover] turbo-frame#slideover').children).to be_empty
      end

      it 'displays a flash message' do
        make_request(name: 'Thursday Retro', columns_attributes: {'0' => {name: 'Happy'}})
        expect(page.css('turbo-stream[target=flash] turbo-frame#flash')).to have_text('Board was successfully created')
      end
    end
  end

  describe 'PATCH #update' do
    let(:board) { create(:board, name: 'Monday Retro') }
    let!(:column) { create(:column, board: board, name: 'Happy') }

    before { sign_in(user, scope: :user) }

    def make_request(id, attributes)
      patch board_url(id), params: {board: attributes}
    end

    context 'when the user is not a participant on the board' do
      it 'blows up' do
        expect do
          make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}})
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      before { create(:board_user, board: board, user: user) }

      it 'blows up' do
        expect do
          make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}})
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is a participant on the board' do
      before { create(:board_user, board: board, user: user) }

      context 'with valid parameters' do
        it 'updates the requested board' do
          make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}})
          expect(board.reload.attributes.symbolize_keys).to include(name: 'Friday Retro')
        end

        it 'updates the requested column' do
          make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}})
          expect(column.reload.attributes.symbolize_keys).to include(name: 'I like')
        end

        it 'redirects to the board' do
          make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}})
          expect(response).to redirect_to(board_url(board))
        end

        it 'broadcasts to replace a board on the boards channel' do
          expect { make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}}) }
            .to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).once
            .with('boards', hash_including(action: :replace, html: a_string_including('Friday Retro'), target: dom_id(board)))
        end

        it 'broadcasts to replace a board on its header channel' do
          expect { make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}}) }
            .to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).once
            .with(board.to_gid_param, hash_including(action: :replace, html: a_string_including('Friday Retro'), target: dom_id(board, 'header')))
        end
      end

      context 'with a valid column' do
        it 'creates a new column' do
          expect { make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}, '1' => {name: 'I wish'}}) }
            .to change(Column, :count).by(1)
        end
      end

      context 'when deleting the last column' do
        it 'does not delete any columns' do
          expect do
            make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, _destroy: 1}})
          end.not_to change(Column, :count)
        end

        it 'is unsuccessful' do
          make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, _destroy: 1}})
          expect(response).not_to be_successful
        end
      end

      context 'with a deleted column' do
        let!(:other_column) { create(:column, board: board, name: 'Apathetic') }

        it 'deletes a column' do
          expect do
            make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, _destroy: 1}, '1' => {id: other_column.id, name: 'Apathetic'}})
          end.to change(Column, :count).by(-1)
        end
      end

      context 'when attempting to delete a column on another board' do
        let!(:column) { create(:column) }
        let!(:other_column) { create(:column, board: board, name: 'Apathetic') }

        it 'blows up' do
          expect { make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, _destroy: 1}, '1' => {id: other_column.id, name: 'Apathetic'}}) }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'with an invalid column' do
        it 'is not successful' do
          make_request(board.id, columns_attributes: [name: ''])
          expect(response).not_to be_successful
        end
      end

      context 'with invalid parameters' do
        it 'is not successful' do
          make_request(board.id, name: '')
          expect(response).not_to be_successful
        end
      end
    end
  end

  describe 'PATCH #update.turbo_stream' do
    let(:board) { create(:board) }
    let!(:column) { create(:column, board: board, name: 'Happy') }

    before do
      create(:board_user, board: board, user: user)
      sign_in(user, scope: :user)
    end

    def make_request(id, attributes)
      patch board_url(id), params: {board: attributes}, headers: {Accept: Mime['turbo_stream'].to_s}
    end

    it 'updates the requested board' do
      make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}})
      expect(board.reload.attributes.symbolize_keys).to include(name: 'Friday Retro')
    end

    it 'broadcasts to replace a board on the boards channel' do
      expect { make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}}) }.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).once.with(
        'boards',
        hash_including(action: :replace, html: a_string_including('Friday Retro'), target: dom_id(board))
      )
    end

    it 'broadcasts to replace a board on its header channel' do
      expect { make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}}) }.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).once.with(
        board.to_gid_param,
        hash_including(action: :replace, html: a_string_including('Friday Retro'), target: dom_id(board, 'header'))
      )
    end

    it 'purges the slideover' do
      make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}})
      expect(page.css('turbo-stream[target=slideover] turbo-frame#slideover').children).to be_empty
    end

    it 'displays a flash message' do
      make_request(board.id, name: 'Friday Retro', columns_attributes: {'0' => {id: column.id, name: 'I like'}})
      expect(page.css('turbo-stream[target=flash] turbo-frame#flash')).to have_text('Board was successfully updated')
    end
  end

  describe 'DELETE #destroy' do
    let(:board) { create(:board) }

    before do
      create(:column, board: board)
      sign_in(user, scope: :user)
    end

    def make_request(id)
      delete board_url(id)
    end

    context 'when the user is not a participant on the board' do
      it 'blows up' do
        expect { make_request(board.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is a guest' do
      let(:user) { create(:user, :guest) }

      before { create(:board_user, board: board, user: user) }

      it 'blows up' do
        expect { make_request(board.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is a participant on the board' do
      before { create(:board_user, board: board, user: user) }

      it 'destroys the requested board' do
        expect { make_request(board.id) }
          .to change(Board, :count).by(-1)
          .and change(Column, :count).by(-1)
      end

      it 'redirects to the boards list' do
        make_request(board.id)
        expect(response).to redirect_to(boards_url)
      end
    end
  end
end
