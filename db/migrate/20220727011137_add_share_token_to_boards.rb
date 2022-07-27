class AddShareTokenToBoards < ActiveRecord::Migration[7.0]
  class Board20220726 < ApplicationRecord
    self.table_name = :boards
  end

  def change
    change_table :boards do |t|
      t.string :share_token, null: true, index: {unique: true}
    end

    reversible do |dir|
      dir.up { Board20220726.find_each { |b| b.update(share_token: Nanoid.generate) } }
    end

    change_column_null :boards, :share_token, false
  end
end
