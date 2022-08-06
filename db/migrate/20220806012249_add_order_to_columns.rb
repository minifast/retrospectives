class AddOrderToColumns < ActiveRecord::Migration[7.0]
  class Column20220806 < ActiveRecord::Base
    self.table_name = :columns
  end

  def change
    change_table :columns do |t|
      t.integer :column_order
    end

    reversible do |dir|
      dir.up { Column20220806.update_all('column_order = EXTRACT(EPOCH FROM created_at)') }
    end
  end
end
