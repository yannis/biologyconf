class AddVegetarianAndPosterAgreementToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :vegetarian, :boolean
    add_column :registrations, :poster_agreement, :boolean
  end
end
