# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: {unique: true}
      t.string :name, null: false
      t.string :image_url, null: false
      t.timestamps null: false
    end
  end
end
