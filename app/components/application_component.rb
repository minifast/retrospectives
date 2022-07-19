class ApplicationComponent < ViewComponent::Base
  include Devise::Controllers::Helpers
  include Turbo::FramesHelper
  include Turbo::StreamsHelper
end
