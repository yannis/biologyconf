class AddDinnerAndDormitoryToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :dinner_category_name, :string
    add_column :registrations, :dormitory, :boolean, default: false
    add_index :registrations, :dinner_category_name
  end
end
