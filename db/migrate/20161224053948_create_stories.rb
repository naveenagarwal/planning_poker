class CreateStories < ActiveRecord::Migration[5.0]
  def change
    create_table :stories do |t|
      t.string :story_no
      t.string :title
      t.text :description
      t.integer :estimated_points
      t.string :estimated_time
      t.references :sprint

      t.timestamps
    end
  end
end
