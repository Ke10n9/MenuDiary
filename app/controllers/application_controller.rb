class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

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
      @eating_times = [["朝食", 1], ["昼食", 2], ["夕食", 3]]
    end

    # dishesモデルのcategoryカラムのバリエーションを指定
    def set_dish_categories
      @dish_categories = [["主菜", 1], ["副菜", 2], ["汁物", 3], ["主食", 4], ["デザート", 5]]
    end
end
