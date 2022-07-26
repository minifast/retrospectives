class CreateColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :columns do |t|
      t.belongs_to :board, null: false, foreign_key: true, index: false
      t.string :name, null: false
      t.index [:board_id, :name], unique: true
      t.timestamps null: false
    end
  end
end
