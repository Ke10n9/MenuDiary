class MealsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update]
  before_action :correct_user, only: [:destroy]


  def create
    @meal = Meal.find_by(meal_params)
    @dish = Dish.find_by(dish_params)
    @meal = current_user.meals.build(meal_params) if @meal.nil?
    @dish = current_user.dishes.build(dish_params) if @dish.nil?
    if @meal.save && @dish.save
      @menu = @meal.menus.build(dish_id: @dish.id)
      @menu.save
      @p_date = Meal.new(meal_params)
      flash[:success] = "メニューを登録しました。"
      redirect_to root_url
    else
      @meals = current_user.meals.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
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
    @meal = Meal.find_by(meal_params)
    err = 0
    @dishes = dishes_params.keys.each do |dishes_id|
      menu = Menu.find_by(meal_id: @meal.id, dish_id: dishes_id)
      dish = Dish.find(dishes_id)
      dish_menus = Menu.where(dish_id: dishes_id)
      if dish_menus.count == 1
        unless dish.update_attributes(dishes_params[dishes_id])
          err += 1
        end
      elsif dish_menus.count > 1
        new_dish = Dish.find_by(name: dishes_params[dishes_id][:name])
        new_dish = current_user.dishes.build(dishes_params[dishes_id]) if new_dish.nil?
        if new_dish.save
          menu.dish_id = new_dish.id
          menu.save
        else
          err += 1
        end
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
      params.require(:dish).permit(:name)
    end

    def dishes_params
      params.permit(dish: :name)[:dish]
    end

    def correct_user
      @meal = current_user.meals.find_by(id:params[:id])
      redirect_to root_url if @meal.nil?
    end

end
