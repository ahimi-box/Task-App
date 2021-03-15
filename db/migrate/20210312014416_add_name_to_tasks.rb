class AddNameToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :name, :string
    add_column :tasks, :description, :string
  end
end
