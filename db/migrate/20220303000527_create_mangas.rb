class CreateMangas < ActiveRecord::Migration[7.0]
  def change
    create_table :mangas do |t|
      t.string :titulo
      t.integer :usuario_id
      t.text :descricao
      t.boolean :finalizado, default: false
      t.timestamps
    end
  end
end
