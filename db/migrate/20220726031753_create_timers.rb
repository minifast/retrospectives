class CreateTimers < ActiveRecord::Migration[7.0]
  def change
    create_table :timers do |t|
      t.integer :duration, null: false
      t.belongs_to :board, null: false, foreign_key: true, index: {unique: true}
      t.timestamps null: false
    end
  end
end
