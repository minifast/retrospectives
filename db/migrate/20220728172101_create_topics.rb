class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.belongs_to :column, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
