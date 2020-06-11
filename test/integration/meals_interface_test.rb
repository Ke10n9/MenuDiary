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
      post meals_path, params: { meal: { date: "", eating_time: "" },
                                dish: { name: "", category: "" } }
    end
    # 有効な送信
    today = Date.today
    eating_time_one = 1
    dish_one = {name: "豚肉", category: 1}
    assert_difference ['Meal.count', 'Menu.count', 'Dish.count'], 1 do
      post meals_path, params: { meal: { date: today,
                                        eating_time: eating_time_one },
                                dish: dish_one }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match dish_one[:name], response.body
    assert_select 'a', text: 'Edit'
    assert_select 'a', text: 'delete'
    # 重複するmeal、新規のdishを送信
    dish_two = {name: "味噌汁", category: 3}
    assert_difference ['Dish.count', 'Menu.count'], 1 do
      assert_no_difference 'Meal.count' do
        post meals_path, params: { meal: { date: today,
                                          eating_time: eating_time_one },
                                  dish: dish_two }
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match dish_two[:name], response.body
    # 新規のmeal、重複するdishを送信
    yesterday = Date.today - 1
    assert_difference ['Meal.count', 'Menu.count'], 1 do
      assert_no_difference 'Dish.count' do
        post meals_path, params: { meal: { date: yesterday,
                                          eating_time: eating_time_one },
                                  dish: dish_one }
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    # 新規のmeal、新規のdishを送信
    eating_time_two = 2
    dish_three = {name: "餃子", category: 1}
    assert_difference ['Meal.count', 'Menu.count', 'Dish.count'], 1 do
        post meals_path, params: { meal: { date: yesterday,
                                          eating_time: eating_time_two },
                                  dish: dish_three }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match dish_three[:name], response.body
    # 編集画面を開く
    first_meal = @user.meals.find_by(date: today,
                                      eating_time: eating_time_one)
    get edit_meal_path(first_meal)
    assert_template 'meals/edit'
    assert_match dish_one[:name], response.body
    assert_match dish_two[:name], response.body
    # 無効な編集
    dish_one_id = Dish.find_by(dish_one).id
    dish_two_id = Dish.find_by(dish_two).id
    patch meal_path(first_meal), params: { meal: { date: today,
                                                  eating_time: eating_time_one },
                                          dish: { dish_one_id => dish_one,
                                                  dish_two_id => {name: "", category: ""} } }
    assert_redirected_to root_url
    follow_redirect!
    assert_match dish_one[:name], response.body
    assert_match dish_two[:name], response.body
    # 複数使われているdishを、既に使われているdishに編集
    changed_menu = Menu.find_by(meal_id: first_meal.id, dish_id: dish_one_id)
    dish_three_id = Dish.find_by(dish_three).id
    assert_no_difference ['Meal.count', 'Menu.count', 'Dish.count'] do
      patch meal_path(first_meal), params: { meal: { date: today,
                                                    eating_time: eating_time_one },
                                            dish: { dish_one_id => dish_three,
                                                    dish_two_id => dish_two } }
    end
    assert_redirected_to root_url
    follow_redirect!
    changed_menu.reload
    assert_equal dish_three_id, changed_menu.dish_id
    # 複数使われているdishを、使われていないdishに編集
    dish_four = {name: "ラーメン", category: 5}
    changed_menu = Menu.find_by(meal_id: first_meal.id, dish_id: dish_three_id)
    assert_no_difference ['Meal.count', 'Menu.count'] do
      assert_difference 'Dish.count', 1 do
        patch meal_path(first_meal), params: { meal: { date: today,
                                                      eating_time: eating_time_one },
                                              dish: { dish_three_id => dish_four,
                                                      dish_two_id => dish_two } }
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    changed_menu.reload
    dish_four_id = Dish.find_by(dish_four).id
    assert_equal dish_four_id, changed_menu.dish_id
    # １つしか使われていないdishを、使われていないdishに編集
    dish_five = {name: "うどん", category: 5}
    changed_menu = Menu.find_by(meal_id: first_meal.id, dish_id: dish_four_id)
    assert_no_difference ['Meal.count', 'Menu.count', 'Dish.count'] do
      patch meal_path(first_meal), params: { meal: { date: today,
                                                    eating_time: eating_time_one },
                                            dish: { dish_four_id => dish_five,
                                                    dish_two_id => dish_two } }
    end
    assert_redirected_to root_url
    follow_redirect!
    changed_menu.reload
    dish_five_id = Dish.find_by(dish_five).id
    assert_equal dish_five_id, changed_menu.dish_id
    # １つしか使われていないdishを、既に使われているdishに編集（編集前に戻る）
    changed_menu = Menu.find_by(meal_id: first_meal.id, dish_id: dish_five_id)
    assert_no_difference ['Meal.count', 'Menu.count'] do
      assert_difference 'Dish.count', -1 do
        patch meal_path(first_meal), params: { meal: { date: today,
                                                      eating_time: eating_time_one },
                                              dish: { dish_five_id => dish_one,
                                                      dish_two_id => dish_two } }
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    changed_menu.reload
    assert_equal dish_one_id, changed_menu.dish_id
    # 表示範囲を変更
    get root_path, params: {date: Date.yesterday}
    assert_match dish_one[:name], response.body
    assert_no_match dish_two[:name], response.body
    # ２度使われているdishを含むmealを削除する
    second_meal = @user.meals.find_by(date: yesterday,
                                    eating_time: eating_time_one)
    assert_difference ['Meal.count', 'Menu.count'], -1 do
      assert_no_difference 'Dish.count' do
        delete meal_path(second_meal)
      end
    end
    assert_redirected_to root_url
    follow_redirect!
    # １度だけ使われているdishを２つ含むmealを削除する
    assert_difference 'Meal.count', -1 do
      assert_difference ['Menu.count', 'Dish.count'], -2 do
        delete meal_path(first_meal)
      end
    end
  end
end
