class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.integer :number
      t.integer :max_page
      t.string :url
      t.references :comic, null: false, foreign_key: true
      t.timestamps
    end
  end
end
