class AddDeletedAtToBoards < ActiveRecord::Migration[7.0]
  def change
    change_table :boards do |t|
      t.datetime :deleted_at, index: {where: 'deleted_at IS NOT NULL'}
    end
  end
end
