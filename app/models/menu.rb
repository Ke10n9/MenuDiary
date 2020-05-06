class Menu < ApplicationRecord
  belongs_to :meal
  belongs_to :dish
  validates :meal_id, presence: true
  validates :dish_id, presence: true
end
