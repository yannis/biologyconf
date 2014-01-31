class AddRegistrationIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :registration_id, :integer
    add_index :events, :registration_id
  end
end
