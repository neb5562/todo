class AddListIdToLists < ActiveRecord::Migration[7.0]
  def change
    add_column :todos, :list_id, :integer 
  end
end
