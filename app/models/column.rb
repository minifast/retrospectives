# == Schema Information
#
# Table name: columns
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  board_id   :bigint           not null
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
  belongs_to :board, inverse_of: :columns
  validates :name, presence: true, uniqueness: {scope: :board_id}
end
