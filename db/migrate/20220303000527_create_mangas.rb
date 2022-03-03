class CreateMangas < ActiveRecord::Migration[7.0]
  def change
    create_table :mangas do |t|
      t.string :titulo
      t.integer :autor_id
      t.text :descricao
      t.timestamps
    end
  end
end
