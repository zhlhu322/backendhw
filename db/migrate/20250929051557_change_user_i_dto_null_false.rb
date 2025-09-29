class ChangeUserIDtoNullFalse < ActiveRecord::Migration[8.0]
  def change
    change_column_null :missions, :user_id, false
  end
end
