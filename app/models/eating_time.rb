class EatingTime < ApplicationRecord
  has_many :meals, foreign_key: "eating_time_id"
  validates :name, presence: true, uniqueness: true, length: {maximum: 5}
  validates :order, presence: true, uniqueness: true, presence: true
end
