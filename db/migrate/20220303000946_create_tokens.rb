class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.integer :usuario_id
      t.string :token
      t.timestamps
    end
  end
end
