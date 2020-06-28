class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  autocomplete :dish, :name, full: true

  def autocomplete_dish_name
    autocompleted_dishes =
        current_user.dishes.where("name like ?", "%#{params[:term]}%").pluck(:name)
    render json: autocompleted_dishes
  end

  private

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # mealsモデルのeating_timeカラムのバリエーションを指定
    def set_eating_times
      @eating_times = [["朝", 1], ["昼", 2], ["夕", 3]]
    end

    # dishesモデルのcategoryカラムのバリエーションを指定
    def set_dish_categories
      @dish_categories = [["主菜", 1], ["副菜", 2], ["汁物", 3], ["主食", 4], ["デザート", 5]]
    end

end
