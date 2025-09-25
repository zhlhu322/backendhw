class AddPriorityToMissions < ActiveRecord::Migration[8.0]
  def change
    add_column :missions, :priority, :integer, default: 1, null: false
  end
end
