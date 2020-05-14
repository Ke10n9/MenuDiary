require 'test_helper'

class MealsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "meal interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # 無効な送信
    assert_no_difference ['Meal.count', 'Menu.count', 'Dish.count'] do
      post meals_path, params: { meal: { date: "",
                                        eating_time_order: 4 },
                                dish: { name: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    date_one = "2020-05-13"
    eating_time_order_one = 1
    dish_one = "豚肉"
    assert_difference ['Meal.count', 'Menu.count', 'Dish.count'], 1 do
      post meals_path, params: { meal: { date: date_one,
                                        eating_time_order: eating_time_order_one },
                                dish: { name: dish_one } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match date_one, response.body
    assert_match dish_one, response.body
    # 重複するmeal、新規のdishを送信
    dish_two = "味噌汁"
    assert_difference ['Dish.count', 'Menu.count'], 1 do
      assert_no_difference 'Meal.count' do
        post meals_path, params: { meal: { date: date_one,
                                          eating_time_order: eating_time_order_one },
                                  dish: { name: dish_two } }
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match dish_two, response.body
    # 新規のmeal、重複するdishを送信
    date_two = "2020-05-14"
    assert_difference ['Meal.count', 'Menu.count'], 1 do
      assert_no_difference 'Dish.count' do
        post meals_path, params: { meal: { date: date_two,
                                          eating_time_order: eating_time_order_one },
                                  dish: { name: dish_one } }
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match date_two, response.body
    # ２度使われているdishを含むmealを削除する
    assert_select 'a', text: 'delete'
    first_meal = @user.meals.find_by(date: date_two,
                                    eating_time_order: eating_time_order_one)
    assert_difference ['Meal.count', 'Menu.count'], -1 do
      assert_no_difference 'Dish.count' do
        delete meal_path(first_meal)
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    # １度だけ使われているdishを２つ含むmealを削除する
    assert_select 'a', text: 'delete'
    second_meal = @user.meals.find_by(date: date_one,
                                      eating_time_order: eating_time_order_one)
    assert_difference 'Meal.count', -1 do
      assert_difference ['Menu.count', 'Dish.count'], -2 do
        delete meal_path(second_meal)
      end
    end

  end
end
