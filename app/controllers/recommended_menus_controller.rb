class RecommendedMenusController < ApplicationController
  before_action :logged_in_user, only: :show

  def show
    dishes = []
    meals = Meal.where(eating_time: 3).order(date: "DESC")
    meals.each do |meal|
      if menus = Menu.where(meal_id: meal.id)
        menus.each do |menu|
          dish = Dish.find(menu.dish_id)
          if dish.category == 1
            dishes.push(dish.name)
          end
        end
      end
    end
    dishes.uniq!.reverse!
    @dishes = dishes[0..4]
  end
end
