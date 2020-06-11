require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User",
                    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "password should be a present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test " password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated dishes should be destroyed" do
    @user.save
    @user.dishes.create!(name: "シチュー", category: 1)
    assert_difference 'Dish.count', -1 do
      @user.destroy
    end
  end

  test "associated meals should be destroyed" do
    @user.save
    @meal = @user.meals.create!(date: meals(:one).date,
                                eating_time: meals(:one).eating_time)
    @meal.menus.create!(dish_id: dishes(:one).id)
    assert_difference ['Meal.count', 'Menu.count'], -1 do
      @user.destroy
    end
  end
end
