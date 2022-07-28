# frozen_string_literal: true

class BoardColumn::Component < ApplicationComponent
  with_collection_parameter :column

  attr_reader :column

  def initialize(column:)
    @column = column
  end
end
