class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.references :episode, null: false, foreign_key: true
      t.integer :number
      t.string :url

      t.timestamps
    end
  end
end
