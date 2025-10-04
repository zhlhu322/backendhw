class AddTag < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.references :mission, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tags, [ :mission_id, :name ], unique: true
  end
end
