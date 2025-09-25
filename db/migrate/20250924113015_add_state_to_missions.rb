class AddStateToMissions < ActiveRecord::Migration[8.0]
  def change
    add_column :missions, :state, :string, null: false, default: "pending"
  end
end
