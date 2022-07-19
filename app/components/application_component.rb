class ApplicationComponent < ViewComponent::Base
  include Devise::Controllers::Helpers
  include Turbo::FramesHelper
end
