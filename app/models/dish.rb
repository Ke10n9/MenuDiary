class Dish < ApplicationRecord
  belongs_to :user
  has_many :menus, foreign_key: "dish_id"
  has_many :meals, through: :menus
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 30 }
end
