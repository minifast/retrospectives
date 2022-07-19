# == Schema Information
#
# Table name: boards
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_boards_on_deleted_at  (deleted_at) WHERE (deleted_at IS NOT NULL)
#  index_boards_on_name        (name) UNIQUE
#
class Board < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true, uniqueness: true
  scope :most_recent, -> { order(created_at: :desc) }
end
