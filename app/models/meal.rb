class Meal < ApplicationRecord
  belongs_to :user
  has_many :menus, dependent: :destroy
  has_many :dishes, through: :menus
  default_scope -> {order(date: :desc, eating_time: :desc)}
  validates :user_id, presence: true
  validates :date, presence: true
  validates :eating_time, presence: true

  def eating_time_name
    # eating_time = self.eating_time
    # @eating_time_hash　= { 1 => "朝食", 2 => "昼食", 3 => "夕食" }
    # return @eating_time_hash[eating_time]
    @eating_time_array = ["朝食", "昼食", "夕食"]
    return @eating_time_array[self.eating_time]
  end
end
