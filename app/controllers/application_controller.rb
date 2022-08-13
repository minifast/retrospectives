class ApplicationController < ActionController::Base
  include Pundit::Authorization

  append_view_path Rails.root.join('app/components')

  private

  def guest_user_params
    {
      image_url: '',
      name: [Rails.application.config_for(:guest).adjectives.sample, Rails.application.config_for(:guest).animals.sample].join(' ')
    }
  end

  def pundit_user
    current_or_guest_user
  end

  def transfer_guest_to_user
    guest_user.board_users.update(user: current_user)
    # rubocop:disable Rails/SkipsModelValidations
    guest_user.topics.update_all(user_id: current_user.id)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
