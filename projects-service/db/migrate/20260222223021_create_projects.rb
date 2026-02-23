class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :color
      t.integer :user_id

      t.timestamps
    end
  end
end
