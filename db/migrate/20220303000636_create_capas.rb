class CreateCapas < ActiveRecord::Migration[7.0]
  def change
    create_table :capas do |t|
      t.integer :manga_id
      t.binary :arquivo
      t.timestamps
    end
  end
end
