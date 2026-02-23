class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.boolean :completed
      t.string :priority
      t.date :due_date
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
