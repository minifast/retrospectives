# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  column_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_topics_on_column_id  (column_id)
#  index_topics_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (column_id => columns.id)
#  fk_rails_...  (user_id => users.id)
#
class Topic < ApplicationRecord
  include Hashid::Rails

  belongs_to :column, inverse_of: :topics
  belongs_to :user, inverse_of: :topics

  has_one :board, through: :column

  validates :name, presence: true
end
