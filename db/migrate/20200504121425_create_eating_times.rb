class CreateEatingTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :eating_times do |t|
      t.string :name

      t.timestamps
    end
  end
end
