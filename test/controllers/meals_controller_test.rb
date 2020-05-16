require 'test_helper'

class MealsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @meal = meals(:one)
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

  test "should redirect destroy for wrong meal" do
    log_in_as(users(:michael))
    meal = meals(:archer_meal)
    assert_no_difference 'Meal.count' do
      delete meal_path(meal)
    end
    assert_redirected_to root_url
  end

end
