class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start
      t.datetime :end
      t.string :classes
      t.string :kind

      t.timestamps

    end
    add_index :events, :start
  end
end
