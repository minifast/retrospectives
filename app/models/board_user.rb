# == Schema Information
#
# Table name: board_users
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  board_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_board_users_on_board_id              (board_id)
#  index_board_users_on_user_id_and_board_id  (user_id,board_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (board_id => boards.id)
#  fk_rails_...  (user_id => users.id)
#
class BoardUser < ApplicationRecord
  belongs_to :board, inverse_of: :board_users
  belongs_to :user, inverse_of: :board_users

  validates :board_id, uniqueness: {scope: :user_id}
end
