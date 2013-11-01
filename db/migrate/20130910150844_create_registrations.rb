class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :institute
      t.string :address
      t.string :city
      t.string :zip_code
      t.string :country

      t.string :title
      t.text :authors
      t.text :body
      t.boolean :talk

      t.timestamps
    end
  end
end
