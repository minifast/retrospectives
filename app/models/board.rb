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

  has_many :columns, inverse_of: :board, dependent: :destroy

  accepts_nested_attributes_for :columns, reject_if: :all_blank, allow_destroy: true
end
