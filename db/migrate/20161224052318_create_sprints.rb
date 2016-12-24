class CreateSprints < ActiveRecord::Migration[5.0]
  def change
    create_table :sprints do |t|
      t.string :name
      t.references :project

      t.timestamps
    end
  end
end
