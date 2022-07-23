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

  has_many :columns, inverse_of: :board, dependent: :destroy
  has_one :timer, inverse_of: :board, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :columns, reject_if: :all_blank, allow_destroy: true

  scope :most_recent, -> { order(created_at: :desc) }
end
