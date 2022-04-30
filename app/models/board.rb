# == Schema Information
#
# Table name: boards
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_boards_on_name  (name) UNIQUE
#
class Board < ApplicationRecord
  validates :name, presence: true
end
