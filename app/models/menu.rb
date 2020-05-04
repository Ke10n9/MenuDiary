class Menu < ApplicationRecord
  belongs_to :user
  validates :meal_id, presence: true
  validates :dish_id, presence: true
end
