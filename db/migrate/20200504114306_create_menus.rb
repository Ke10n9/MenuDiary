class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.integer :meal_id
      t.integer :dish_id
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :menus, :meal_id
  end
end
