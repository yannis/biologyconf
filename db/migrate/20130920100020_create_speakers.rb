class CreateSpeakers < ActiveRecord::Migration
  def change
    create_table :speakers do |t|
      t.string :first_name
      t.string :last_name
      t.string :title
      t.text :description
      t.string :url

      t.timestamps
    end
    add_index :speakers, :last_name
  end
end
