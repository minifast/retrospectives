class ApplicationController < ActionController::Base
  include Pundit::Authorization

  append_view_path Rails.root.join('app/components')

  def guest_user_params
    {
      image_url: '/assets/guest/profile.svg',
      name: [t('guest.adjectives').sample, t('guest.animals').sample].join(' ')
    }
  end

  def pundit_user
    current_or_guest_user
  end
end
