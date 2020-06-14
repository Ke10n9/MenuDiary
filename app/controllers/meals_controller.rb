class MealsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update]
  before_action :correct_user, only: [:destroy, :edit, :update]
  before_action :set_dish_categories, only: [:create, :edit, :update] #ApplicationController
  before_action :set_eating_times, only: :create #ApplicationController

  def create
    meal = Meal.find_by(meal_params)
    dish = Dish.find_by(dish_params)
    meal.nil? ? @meal = current_user.meals.build(meal_params) : @meal = meal
    dish.nil? ? @dish = current_user.dishes.build(dish_params) : @dish = dish
    if @meal.valid? && @dish.valid?
      @meal.save if meal.nil?
      @dish.save if dish.nil?
      menu = @meal.menus.build(dish_id: @dish.id)
      menu.save ? flash[:success] = "メニューを登録しました。"
                  : flash[:danger] = "メニューが重複しています。"
      redirect_to root_url
    else
      params[:date] ? @date = params[:date].to_date : @date = Date.today
      render 'static_pages/home'
    end
  end

  def destroy
    @meal = Meal.find(params[:id])
    t_menus = Menu.where(meal_id: params[:id])
    t_menus.each do |t|
      if Menu.where.not(meal_id: @meal.id).find_by(dish_id: t.dish_id).nil?
        Dish.find(t.dish_id).destroy
      end
    end
    @meal.destroy
    flash[:success] = "メニューを削除しました。"
    redirect_to request.referrer || root_url
  end

  def edit
    @meal = Meal.find(params[:id])
    @dishes = @meal.dishes.all
  end

  def update
    @meal = Meal.find_by(meal_params) #編集するmeal
    err = 0 #エラー数の初期値
    @dishes = dishes_params.keys.each do |dishes_id| #@mealのdish分繰り返し
      dish = Dish.find(dishes_id) #編集前のdishを探す
      menu = Menu.find_by(meal_id: @meal.id, dish_id: dishes_id) #@mealで編集前dishが含まれるmenu
      dish_menus = Menu.where(dish_id: dishes_id) #全menuで編集前dishが含まれるもの
      new_dish = Dish.find_by(name: dishes_params[dishes_id][:name],
                      category: dishes_params[dishes_id][:category]) #編集後のdishが既にあるか調べる
      if new_dish.nil? #もしnew_dishが無くて
        if dish_menus.count == 1 #編集前dishが他のmenuで使われていなければ
          unless dish.update_attributes(dishes_params[dishes_id])
            err += 1
          end
        elsif dish_menus.count > 1
          new_dish = current_user.dishes.build(dishes_params[dishes_id])
          new_dish.save if new_dish.valid?
        end
      elsif dish != new_dish && dish_menus.count == 1
        dish.destroy
      end
      menu.dish_id = new_dish.id unless new_dish.nil?
      unless menu.save
        err += 1
      end
    end
    unless err == 0
      flash[:danger] = "#{err}個のエラーがありました。エラー箇所は元に戻します。"
    else
      flash[:success] = "メニューは正常に編集されました。"
    end
    redirect_to root_url
  end


  private

    def meal_params
      params.require(:meal).permit(:date, :eating_time)
    end

    def dish_params
      params.require(:dish).permit(:name, :category)
    end

    def dishes_params
      params.permit(dish: [:name, :category])[:dish]
    end

    def correct_user
      @meal = current_user.meals.find_by(id:params[:id])
      redirect_to root_url if @meal.nil?
    end
end
