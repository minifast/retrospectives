require 'rails_helper'

RSpec.describe Boards::Columns::TopicsController, type: :request do
  let(:board) { create(:board) }
  let(:column) { create(:column, board: board) }

  describe 'GET #index' do
    before { create(:topic, column: column, name: 'beans') }

    def make_request(board_id, column_id)
      get board_column_topics_url(board_id, column_id)
    end

    context 'when the user is not signed in' do
      it 'does not render the topic' do
        make_request(board.id, column.id)
        expect(page).to have_no_content('beans')
      end
    end

    context 'when the user is not attached to the board' do
      let(:user) { create(:user) }

      before { sign_in(user, scope: :user) }

      it 'does not render the topic' do
        make_request(board.id, column.id)
        expect(page).to have_no_content('beans')
      end
    end

    context 'when the user is attached to the board' do
      let(:user) { create(:user) }

      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'renders the topic' do
        make_request(board.id, column.id)
        expect(page).to have_content('beans')
      end
    end

    context 'when the guest is attached to the board' do
      let(:user) { create(:user, :guest) }

      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'renders the topic' do
        make_request(board.id, column.id)
        expect(page).to have_content('beans')
      end
    end
  end

  describe 'GET #new' do
    def make_request(board_id, column_id)
      get new_board_column_topic_url(board_id, column_id)
    end

    context 'when the user is not signed in' do
      it 'blows up' do
        expect { make_request(board.id, column.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is not attached to the board' do
      let(:user) { create(:user) }

      before { sign_in(user, scope: :user) }

      it 'blows up' do
        expect { make_request(board.id, column.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is attached to the board' do
      let(:user) { create(:user) }

      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'renders a form' do
        make_request(board.id, column.id)
        expect(page).to have_field('Topic name').and have_button('Create Topic')
      end
    end

    context 'when the guest is attached to the board' do
      let(:user) { create(:user, :guest) }

      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'renders a form' do
        make_request(board.id, column.id)
        expect(page).to have_field('Topic name').and have_button('Create Topic')
      end
    end
  end

  describe 'POST #create' do
    def make_request(board_id, column_id, topic_params)
      post board_column_topics_url(board_id, column_id), params: {topic: topic_params}
    end

    context 'when the user is not signed in' do
      it 'blows up' do
        expect { make_request(board.id, column.id, name: 'Taco') }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is not attached to the board' do
      let(:user) { create(:user) }

      before { sign_in(user, scope: :user) }

      it 'blows up' do
        expect { make_request(board.id, column.id, name: 'Taco') }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when the user is attached to the board' do
      let(:user) { create(:user) }

      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'creates a topic' do
        expect { make_request(board.id, column.id, name: 'Taco') }.to change(Topic, :count).by(1)
      end

      it 'sends a topic to the board channel' do
        expect { make_request(board.id, column.id, name: 'Taco') }
          .to have_enqueued_job(Turbo::Streams::ActionBroadcastJob)
          .with(board.to_gid_param, hash_including(action: :prepend, html: a_string_including('Taco')))
      end
    end

    context 'when the guest is attached to the board' do
      let(:user) { create(:user, :guest) }

      before do
        create(:board_user, board: board, user: user)
        sign_in(user, scope: :user)
      end

      it 'creates a topic' do
        expect { make_request(board.id, column.id, name: 'Taco') }.to change(Topic, :count).by(1)
      end

      it 'sends a topic to the board channel' do
        expect { make_request(board.id, column.id, name: 'Taco') }
          .to have_enqueued_job(Turbo::Streams::ActionBroadcastJob)
          .with(board.to_gid_param, hash_including(action: :prepend, html: a_string_including('Taco')))
      end
    end
  end
end
