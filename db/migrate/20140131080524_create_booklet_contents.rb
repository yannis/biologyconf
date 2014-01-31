class CreateBookletContents < ActiveRecord::Migration
  def change
    create_table :booklet_contents do |t|
      t.string :identifier
      t.string :title
      t.integer :title_size
      t.text :text

      t.timestamps
    end
    add_index :booklet_contents, :identifier
  end
end
