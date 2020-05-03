class AddNumToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :number, :integer
  end
end
