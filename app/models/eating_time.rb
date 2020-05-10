class EatingTime < ApplicationRecord
  has_many :meals, primary_key: "order", foreign_key: "eating_time_order"
  validates :name, presence: true, uniqueness: true, length: {maximum: 5}
  validates :order, presence: true, uniqueness: true, presence: true
end
