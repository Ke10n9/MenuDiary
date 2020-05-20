require 'test_helper'

class DishTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @dish = @user.dishes.build(name: "鮭")
  end

  test "should be valid" do
    assert @dish.valid?
  end

  test "user id should be present" do
    @dish.user_id = nil
    assert_not @dish.valid?
  end

  test "name should be present" do
    @dish.name = " "
    assert_not @dish.valid?
  end

  test "name should be at most 30 characters" do
    @dish.name = "a" * 31
    assert_not @dish.valid?
  end
end
