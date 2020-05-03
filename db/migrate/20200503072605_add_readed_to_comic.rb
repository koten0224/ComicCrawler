class AddReadedToComic < ActiveRecord::Migration[6.0]
  def change
    add_column :comics, :readed, :integer
  end
end
