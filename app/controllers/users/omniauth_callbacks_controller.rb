class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  class GoogleUser
    include ActiveModel::Model

    attr_accessor :auth_hash

    delegate :info, to: :auth_hash
    delegate :email, :name, :image, to: :info

    validates :email, :name, :image, presence: true
    validates :email, format: {with: Devise.email_regexp, allow_blank: false}

    def user
      @user ||= User.create_with(name: name, image_url: image).find_or_create_by(email: email.downcase)
    end

    def save
      return false unless valid?
      return false unless user.valid?

      user.update(name: name, image_url: image)
      true
    end
  end

  def google_oauth2
    google_user = GoogleUser.new(auth_hash: request.env["omniauth.auth"])

    if google_user.save
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "Google")
      sign_in_and_redirect google_user.user, event: :authentication
    else
      flash[:alert] = I18n.t("devise.omniauth_callbacks.failure", kind: "Google", reason: google_user.user.errors.full_messages.join("\n"))
      redirect_to root_path
    end
  end
end
