class RemoveTagsFromMissions < ActiveRecord::Migration[8.0]
  def change
    remove_column :missions, :tags, :string, array: true, default: []
  end
end
