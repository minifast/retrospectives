class ApplicationComponent < ViewComponent::Base
  include Devise::Controllers::Helpers
  include DeviseGuests::Controllers::Helpers
  include Pundit::Authorization
  include Turbo::FramesHelper
  include Turbo::StreamsHelper

  def pundit_user
    current_or_guest_user
  end
end
