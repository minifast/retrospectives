# == Schema Information
#
# Table name: timers
#
#  id         :bigint           not null, primary key
#  duration   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  board_id   :bigint           not null
#
# Indexes
#
#  index_timers_on_board_id  (board_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (board_id => boards.id)
#
class Timer < ApplicationRecord
  belongs_to :board, inverse_of: :timer
  validates :duration, presence: true, numericality: {greater_than: 0}
  validates :board_id, uniqueness: true

  def ends_at
    duration.seconds.since(created_at)
  end
end
