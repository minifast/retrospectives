class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  class GoogleUser
    include ActiveModel::Model

    attr_accessor :auth_hash

    delegate :info, to: :auth_hash
    delegate :email, to: :info

    validates :email, presence: true

    def user
      @user ||= User.create_with(password: Devise.friendly_token[0,20]).create_or_find_by(email: email.downcase)
    end

    def save
      return false unless valid?

      user
      true
    end
  end

  def google_oauth2
    google_user = GoogleUser.new(auth_hash: request.env['omniauth.auth'])

    if google_user.save
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Google')
      sign_in_and_redirect google_user.user, event: :authentication
    else
      redirect_to new_user_session_path, alert: google_user.errors.full_messages.join("\n")
    end
  end
end
