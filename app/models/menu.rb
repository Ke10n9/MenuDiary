class Menu < ApplicationRecord
  belongs_to :meal
  belongs_to :dish
  validates :meal_id, presence: true, uniqueness: { scope: :dish_id }
  validates :dish_id, presence: true, uniqueness: { scope: :meal_id }
end
