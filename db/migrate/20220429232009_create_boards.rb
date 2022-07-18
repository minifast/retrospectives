class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :name, null: false, index: {unique: true}

      t.timestamps null: false
    end
  end
end
