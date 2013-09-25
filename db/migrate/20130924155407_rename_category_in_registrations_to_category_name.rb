class RenameCategoryInRegistrationsToCategoryName < ActiveRecord::Migration
  def change
    rename_column :registrations, :category, :category_name
  end
end
