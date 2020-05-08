class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.references :item, polymorphic: true, null: false
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
