class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.references :meal, foreign_key: true
      t.integer :dish_id

      t.timestamps
    end
  end
end
