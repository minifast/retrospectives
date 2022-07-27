class ApplicationController < ActionController::Base
  include Pundit::Authorization

  append_view_path Rails.root.join('app/components')

  def guest_user_params
    {
      image_url: '/assets/guest/profile.svg',
      name: [Rails.application.config_for(:guest).adjectives.sample, Rails.application.config_for(:guest).animals.sample].join(' ')
    }
  end

  def pundit_user
    current_or_guest_user
  end
end
