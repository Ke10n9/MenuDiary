require 'test_helper'

class MenuTest < ActiveSupport::TestCase

  def setup
    @menu = Menu.new(meal_id: meals(:two).id, dish_id: dishes(:one).id)
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
