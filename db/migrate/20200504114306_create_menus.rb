class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.integer :dish_id
      t.references :meal, foreign_key: true

      t.timestamps
    end
  end
end
