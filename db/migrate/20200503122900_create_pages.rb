class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.references :comic, null: false, foreign_key: true
      t.integer :episode
      t.string :url

      t.timestamps
    end
  end
end
