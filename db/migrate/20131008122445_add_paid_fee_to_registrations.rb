class AddPaidFeeToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :paid_fee, :decimal, :precision => 8, :scale => 2, :default => 0
    add_index :registrations, :paid_fee
  end
end
