class AddDeviseGuestsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.boolean :guest, default: false, null: false
    end
  end
end
