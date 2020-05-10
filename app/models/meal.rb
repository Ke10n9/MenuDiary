class Meal < ApplicationRecord
  belongs_to :user
  has_many :menus, dependent: :destroy
  has_many :dishes, through: :menus
  has_many :eating_times
  default_scope -> {order(date: :desc, eating_time_order: :desc)}
  validates :user_id, presence: true
  validates :date, presence: true
  validates :eating_time_order, presence: true
end
