class CreateImagens < ActiveRecord::Migration[7.0]
  def change
    create_table :imagens do |t|

      t.timestamps
    end
  end
end
