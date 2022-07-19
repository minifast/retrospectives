# frozen_string_literal: true

class Avatar::Component < ApplicationComponent
  with_collection_parameter :user

  attr_reader :user

  def initialize(user:)
    @user = user
  end
end
