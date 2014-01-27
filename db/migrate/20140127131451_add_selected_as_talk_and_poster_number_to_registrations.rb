class AddSelectedAsTalkAndPosterNumberToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :selected_as_talk, :boolean
    add_column :registrations, :poster_number, :integer

    add_index :registrations, :poster_number
    add_index :registrations, :selected_as_talk
  end
end
