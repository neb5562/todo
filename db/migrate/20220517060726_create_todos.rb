class CreateTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.string :label
      t.integer :user_id
      t.boolean :is_done, default: false
      t.datetime :deadline, default: nil
      t.timestamps
    end
  end
end
