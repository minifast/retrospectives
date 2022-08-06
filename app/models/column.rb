# == Schema Information
#
# Table name: columns
#
#  id           :bigint           not null, primary key
#  column_order :integer
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  board_id     :bigint           not null
#
# Indexes
#
#  index_columns_on_board_id_and_name  (board_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (board_id => boards.id)
#
class Column < ApplicationRecord
  include Hashid::Rails
  include RankedModel

  ranks :column_order

  belongs_to :board, inverse_of: :columns

  has_many :topics, inverse_of: :column, dependent: :destroy

  validates :name, presence: true, uniqueness: {scope: :board_id}

  scope :ranked, -> { rank(:column_order).all }
end
