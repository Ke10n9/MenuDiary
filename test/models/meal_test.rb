require 'test_helper'

class MealTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @meal = @user.meals.build(date: "2020/5/4", time: 2)
  end

  test "should be valid" do
    assert @meal.valid?
  end

  test "date should be present" do
    @meal.date = nil
    assert_not @meal.valid?
  end

  test "time should be present" do
    @meal.time = nil
    assert_not @meal.valid?
  end
end
