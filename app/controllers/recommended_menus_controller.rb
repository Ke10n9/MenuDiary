class RecommendedMenusController < ApplicationController
  before_action :logged_in_user, only: :show
  before_action :set_eating_time, only: :show
  before_action :set_eating_times, only: :show #ApplicationController
  before_action :set_dish_categories, only: :show #ApplicationController

  def show
    dishes = Array.new(3){Array.new()}
      @eating_time == "" ?
        meals = current_user.meals.all.order(date: "DESC", eating_time: "DESC").limit(270)
        : meals = current_user.meals.where(eating_time: @eating_time).order(date: "DESC").limit(90)
    if meals
      meals.each do |meal|
        if menus = Menu.where(meal_id: meal.id)
          menus.each do |menu|
            dish = Dish.find(menu.dish_id)
            dishes[dish.category.to_i-1] << dish.name
          end
        end
      end
    end
    @dishes = []
    dishes.each_with_index do |di, index|
      di.uniq!
      di.reverse!
      @dishes << di[0..4]
    end
  end

  private

    def set_eating_time
      params[:eating_time] ? @eating_time = params[:eating_time]
                          : @eating_time = ""
    end
end
