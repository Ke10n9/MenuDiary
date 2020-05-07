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
    @meal = current_user.meals.find(params[:id])
    t_menus = Menu.where(meal_id: params[:id])
    t_menus.each do |t|
      if Menu.where.not(meal_id: @meal.id).find_by(dish_id: t.dish_id).nil?
        Dish.find(t.dish_id).destroy
      end
    end
    @meal.destroy
  end

  private

    def meal_params
      params.require(:meal).permit(:date, :eating_time)
    end

    def dish_params
      params.require(:dish).permit(:name)
    end

end
