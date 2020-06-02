require 'test_helper'

class MenuTest < ActiveSupport::TestCase

  def setup
    @meal = meals(:two)
    @other_meal = meals(:three)
    @dish = dishes(:one)
    @other_dish = dishes(:two)
    @menu = Menu.new(meal_id: @meal.id, dish_id: @dish.id)
  end

  test "should be valid" do
    assert @menu.valid?
  end

  test "meal id should be presence" do
    @menu.meal_id = nil
    assert_not @menu.valid?
  end

  test "dish id should be presence" do
    @menu.dish_id = nil
    assert_not @menu.valid?
  end

  test "combination of meal_id and dish_id should be unique" do
    # meal_idのみ重複はOK
    duplicate_meal_id = Menu.new(meal_id: @meal.id, dish_id: @other_dish.id)
    duplicate_meal_id.save
    assert @meal.valid?
    # dish_idのみ重複はOK
    duplicate_dish_id = Menu.new(meal_id: @other_meal.id, dish_id: @dish.id)
    duplicate_dish_id.save
    assert @meal.valid?
    # meal_idとdish_idの組み合わせが重複はNG
    duplicate_menu = Menu.new(meal_id: @meal.id, dish_id: @dish.id)
    duplicate_menu.save
    assert_not @menu.valid?
  end
end
