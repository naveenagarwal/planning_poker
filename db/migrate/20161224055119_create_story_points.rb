class CreateStoryPoints < ActiveRecord::Migration[5.0]
  def change
    create_table :story_points do |t|
      t.references :user
      t.references :story
      t.integer :estimated_points
      t.string :estimated_time

      t.timestamps
    end
  end
end
