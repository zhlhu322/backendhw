class AddTagsToMissions < ActiveRecord::Migration[8.0]
  def change
    add_column :missions, :tags, :string, array: true, default: []
  end
end
