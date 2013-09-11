class CreateAbstracts < ActiveRecord::Migration
  def change
    create_table :abstracts do |t|
      t.string :title
      t.text :authors
      t.text :body
      t.belongs_to :registration
      t.boolean :talk

      t.timestamps
    end
  end
end
