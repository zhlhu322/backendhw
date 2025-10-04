class ConvertTagsToManyToMany < ActiveRecord::Migration[8.0]
  def change
    remove_index :tags, column: [ :mission_id, :name ]
    remove_reference :tags, :mission, foreign_key: true, null: false
    add_index :tags, :name, unique: true

    create_table :taggings do |t|
      t.references :mission, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :taggings, [ :mission_id, :tag_id ], unique: true
  end
end
