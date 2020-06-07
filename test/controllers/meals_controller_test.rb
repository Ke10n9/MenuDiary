require 'test_helper'

class MealsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @meal = meals(:one)
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect create when not logged in" do
    assert_no_difference ['Meal.count', 'Menu.count', 'Dish.count'], 1 do
      post meals_path, params: { meal: { date: "2020/5/12",
                                        eating_time: 3 },
                                dish: { name: "豚肉" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Meal.count' do
      delete meal_path(@meal)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as wrong user" do
    log_in_as(@other_user)
    meal = meals(:one)
    assert_no_difference 'Meal.count' do
      delete meal_path(meal)
    end
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get edit_meal_path(@meal)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_meal_path(@meal)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch meal_path(@meal), params: { meal: { name: "update" } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch meal_path(@meal), params: { meal: { name: "update" } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
