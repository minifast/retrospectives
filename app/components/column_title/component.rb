# frozen_string_literal: true

class ColumnTitle::Component < ApplicationComponent
  attr_reader :column

  def initialize(column:)
    @column = column
  end
end
