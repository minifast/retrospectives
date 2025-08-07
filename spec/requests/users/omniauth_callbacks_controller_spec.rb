require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController do
  describe "GET #google_oauth2" do
    context "when the user data is valid" do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(uid: "123545", info: {email: "User@ministryofvelocity.com", name: "User", image: "http://example.com"})
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      end

      it "redirects to the root path" do
        get user_google_oauth2_omniauth_callback_path
        expect(response).to redirect_to(root_path)
      end

      it "creates a user" do
        expect { get user_google_oauth2_omniauth_callback_path }.to change(User, :count).by(1)
      end

      context "when the user already exists" do
        before do
          create(:user, email: "user@ministryofvelocity.com")
        end

        it "does not create a user" do
          expect { get user_google_oauth2_omniauth_callback_path }.not_to change(User, :count)
        end
      end
    end

    context "when the user data is invalid" do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(uid: "123545", info: {email: ""})
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      end

      it "redirects to the sign-in path" do
        get user_google_oauth2_omniauth_callback_path
        expect(response).to redirect_to(root_path)
      end

      it "does not create a user" do
        expect { get user_google_oauth2_omniauth_callback_path }.not_to change(User, :count)
      end
    end
  end
end
