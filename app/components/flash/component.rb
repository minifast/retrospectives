# frozen_string_literal: true

class Flash::Component < ApplicationComponent
  attr_reader :flash

  def initialize(flash:)
    @flash = flash
  end
end
