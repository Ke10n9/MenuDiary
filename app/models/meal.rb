class Meal < ApplicationRecord
  belongs_to :user
  has_many :menus, dependent: :destroy
  has_many :dishes, through: :menus
  validates :user_id, presence: true
  validates :date, presence: true
  validates :eating_time, presence: true
end
