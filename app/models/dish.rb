class Dish < ApplicationRecord
  belongs_to :user
  has_many :menus, foreign_key: "dish_id"
  has_many :meals, through: :menus
  validates :user_id, presence: true, uniqueness: { scope: :name }
  validates :name, presence: true, length: { maximum: 30 }#,
            # uniqueness: { scope: [:user_id, :category] }
  validates :category, presence: true#, uniqueness: { scope: [:user_id, :name] }
  # scope :scope_name, ->(term) { where("name LIKE ?", "%#{term}%").order(:name) }
end
