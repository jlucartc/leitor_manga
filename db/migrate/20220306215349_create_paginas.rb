class CreatePaginas < ActiveRecord::Migration[7.0]
  def change
    create_table :paginas do |t|
      t.string :nome
      t.integer :capitulo_id
      t.integer :sequencia
      t.binary :arquivo
      t.timestamps
    end
  end
end
