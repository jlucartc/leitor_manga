class CreateFavoritos < ActiveRecord::Migration[7.0]
  def change
    create_table :favoritos do |t|
      t.integer :manga_id
      t.integer :usuario_id
      t.timestamps
    end
  end
end
