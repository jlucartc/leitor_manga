class CreateFavoritos < ActiveRecord::Migration[7.0]
  def change
    create_table :favoritos do |t|

      t.timestamps
    end
  end
end
