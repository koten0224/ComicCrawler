class CreateComics < ActiveRecord::Migration[6.0]
  def change
    create_table :comics do |t|
      t.string :name
      t.string :url
      t.integer :latest_episode

      t.timestamps
    end
  end
end
