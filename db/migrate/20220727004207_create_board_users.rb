class CreateBoardUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :board_users do |t|
      t.belongs_to :board, null: false, foreign_key: true, index: true
      t.belongs_to :user, null: false, foreign_key: true, index: false
      t.index [:user_id, :board_id], unique: true
      t.datetime :created_at, null: false
    end
  end
end
