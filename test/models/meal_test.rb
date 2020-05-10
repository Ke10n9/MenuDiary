require 'test_helper'

class MealTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @meal = @user.meals.build(date: "2020/5/4", eating_time_order: 3)
  end

  test "should be valid" do
    assert @meal.valid?
  end

  test "date should be present" do
    @meal.date = nil
    assert_not @meal.valid?
  end

  test "eating time order should be present" do
    @meal.eating_time_order = nil
    assert_not @meal.valid?
  end

  test 'associated menus should be destroyed' do
    @user.save
    @meal.save
    @meal.menus.create!(dish_id: dishes(:one).id)
    assert_difference 'Menu.count', -1 do
      @meal.destroy
    end
  end

  test "order should be most recent first" do
    assert_equal meals(:most_recent), Meal.first
  end
end
