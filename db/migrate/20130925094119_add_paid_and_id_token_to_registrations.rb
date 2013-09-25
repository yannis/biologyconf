class AddPaidAndIdTokenToRegistrations < ActiveRecord::Migration
  def up
    add_column :registrations, :paid, :boolean, default: false
    add_column :registrations, :id_token, :string
  end
end
