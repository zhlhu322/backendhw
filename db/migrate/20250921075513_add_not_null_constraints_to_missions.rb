class AddNotNullConstraintsToMissions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :missions, :name, false
    change_column_null :missions, :description, false
  end
end
