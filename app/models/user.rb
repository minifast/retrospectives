# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  guest      :boolean          default(FALSE), not null
#  image_url  :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :board_users, inverse_of: :user, dependent: :destroy
  has_many :topics, inverse_of: :user, dependent: :destroy
  has_many :boards, through: :board_users

  validates :email, :name, :image_url, presence: true
  validates :email, uniqueness: {allow_blank: true, case_sensitive: true}, if: :will_save_change_to_email?
  validates :email, format: {with: Devise.email_regexp, allow_blank: false}, if: :will_save_change_to_email?
end
