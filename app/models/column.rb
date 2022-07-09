# == Schema Information
#
# Table name: columns
#
#  id         :bigint           not null, primary key
#  name       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  board_id   :bigint           not null
#
# Indexes
#
#  index_columns_on_board_id  (board_id)
#
# Foreign Keys
#
#  fk_rails_...  (board_id => boards.id)
#
class Column < ApplicationRecord
  belongs_to :board, optional: true

  validates :title, presence: true
end
