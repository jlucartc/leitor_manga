class CreateImagens < ActiveRecord::Migration[7.0]
  def change
    create_table :imagens do |t|
      t.integer :capitulo_id
      t.integer :sequencia
      t.binary :arquivo
      t.timestamps
    end
  end
end
