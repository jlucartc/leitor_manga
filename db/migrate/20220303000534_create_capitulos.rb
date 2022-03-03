class CreateCapitulos < ActiveRecord::Migration[7.0]
  def change
    create_table :capitulos do |t|
      t.integer :manga_id
      t.string :titulo
      t.timestamps
    end
  end
end
