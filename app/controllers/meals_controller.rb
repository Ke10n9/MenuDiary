class MealsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @meal = Meal.find_by(meal_params)
    @dish = Dish.find_by(dish_params)
    @meal = current_user.meals.build(meal_params) if @meal.nil?
    @dish = current_user.dishes.build(dish_params) if @dish.nil?
    if @meal.save && @dish.save
      @menu = @meal.menus.build(dish_id: @dish.id)
      @menu.save
      flash[:success] = "メニューを登録しました。"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def meal_params
      params.require(:meal).permit(:date, :eating_time)
    end

    def dish_params
      params.require(:dish).permit(:name)
    end

end
