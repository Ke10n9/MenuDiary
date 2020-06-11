require 'test_helper'

class DishTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @name = "しゃぶしゃぶ"
    @other_name = "焼肉"
    @category = 1
    @dish = @user.dishes.build(name: @name, category: @category)
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

  test "category should be present" do
    @dish.category = " "
    assert_not @dish.valid?
  end

  test "combination of name and user should be unique" do
    # name重複はOK
    duplicate_name = @other_user.dishes.build(name: @name, category: @category)
    duplicate_name.save
    assert @dish.valid?
    # user重複はOK
    duplicate_user = @user.dishes.build(name: @other_name, category: @category)
    duplicate_user.save
    assert @dish.valid?
    # nameとuserの組み合わせが重複はNG
    duplicate_dish = @user.dishes.build(name: @name, category: @category)
    duplicate_dish.save
    assert_not @dish.valid?
  end
end
