# frozen_string_literal: true

class Flash::Component < ViewComponent::Base
  attr_reader :flash
  def initialize(flash:)
    @flash = flash
  end
end
