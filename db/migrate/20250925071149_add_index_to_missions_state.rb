class AddIndexToMissionsState < ActiveRecord::Migration[8.0]
  def change
    add_index :missions, :state
  end
end
