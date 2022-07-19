# frozen_string_literal: true

class Slideover::Component < ApplicationComponent
  attr_reader :title, :description

  def initialize(title: nil, description: nil)
    @title = title
    @description = description
  end
end
