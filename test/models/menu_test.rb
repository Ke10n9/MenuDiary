require 'test_helper'

class MenuTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @menu = @user.menus.build(meal_id: 1, dish_id: 1)
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
end
