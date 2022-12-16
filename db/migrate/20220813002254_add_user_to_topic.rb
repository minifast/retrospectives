class AddUserToTopic < ActiveRecord::Migration[7.0]
  class Topic20220812 < ActiveRecord::Base
    self.table_name = :topics
  end

  class User20220812 < ActiveRecord::Base
    self.table_name = :users
  end

  def change
    add_reference :topics, :user, foreign_key: true

    reversible do |dir|
      dir.up do
        user = User20220812.first
        Topic20220812.update_all(user_id: user.id) if user.present?
      end
    end

    change_column_null :topics, :user_id, false
  end
end
