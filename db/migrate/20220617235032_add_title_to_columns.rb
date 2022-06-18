class AddTitleToColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :columns, :title, :string
  end
end
