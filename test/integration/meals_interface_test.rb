require 'test_helper'

class MealsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "meal interface" do
    log_in_as(@user)
    get root_path
    # 無効な送信
    assert_no_difference ['Meal.count', 'Menu.count', 'Dish.count'] do
      post meals_path, params: { meal: { date: "",
                                        eating_time: "" },
                                dish: { name: "" } }
    end
    # 有効な送信
    today = Date.today
    eating_time_one = 1
    dish_one = "豚肉"
    assert_difference ['Meal.count', 'Menu.count', 'Dish.count'], 1 do
      post meals_path, params: { meal: { date: today,
                                        eating_time: eating_time_one },
                                dish: { name: dish_one } }
    end
    assert_redirected_to root_url
    follow_redirect!
    # assert_match today, response.body
    assert_match dish_one, response.body
    # 重複するmeal、新規のdishを送信
    dish_two = "味噌汁"
    assert_difference ['Dish.count', 'Menu.count'], 1 do
      assert_no_difference 'Meal.count' do
        post meals_path, params: { meal: { date: today,
                                          eating_time: eating_time_one },
                                  dish: { name: dish_two } }
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match dish_two, response.body
    # 新規のmeal、重複するdishを送信
    yesterday = Date.today - 1
    assert_difference ['Meal.count', 'Menu.count'], 1 do
      assert_no_difference 'Dish.count' do
        post meals_path, params: { meal: { date: yesterday,
                                          eating_time: eating_time_one },
                                  dish: { name: dish_one } }
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    # ２度使われているdishを含むmealを削除する
    # assert_select 'a', text: 'delete'
    first_meal = @user.meals.find_by(date: yesterday,
                                    eating_time: eating_time_one)
    assert_difference ['Meal.count', 'Menu.count'], -1 do
      assert_no_difference 'Dish.count' do
        delete meal_path(first_meal)
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    # １度だけ使われているdishを２つ含むmealを削除する
    # assert_select 'a', text: 'delete'
    second_meal = @user.meals.find_by(date: today,
                                      eating_time: eating_time_one)
    assert_difference 'Meal.count', -1 do
      assert_difference ['Menu.count', 'Dish.count'], -2 do
        delete meal_path(second_meal)
      end
    end
  end
end
