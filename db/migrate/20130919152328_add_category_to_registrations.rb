class AddCategoryToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :category, :string
    add_index :registrations, :category
  end
end
