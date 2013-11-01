class AddTimestampIdToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :timestamp_id, :string
    add_index :registrations, :timestamp_id
  end
end
