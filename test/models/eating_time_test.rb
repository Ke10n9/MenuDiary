require 'test_helper'

class EatingTimeTest < ActiveSupport::TestCase

  def setup
    @eating_time = eating_times(:breakfast)
    @invalid_one = EatingTime.new(name: "夕食", order: 2)
    @invalid_two = EatingTime.new(name: "昼食", order: 3)
  end

  test "should be valid" do
    assert @eating_time.valid?
  end

  test "name should be present" do
    @eating_time.name = " "
    assert_not @eating_time.valid?
  end

  test "name should be at most 5 characters" do
    @eating_time.name = 'a' * 6
    assert_not @eating_time.valid?
  end

  test "order should be present" do
    @eating_time.order = nil
    assert_not @eating_time.valid?
  end

  test "name and order should be unique" do
    @eating_time.save
    assert_no_difference 'EatingTime.count' do
      @invalid_one.save
      @invalid_two.save
    end
  end
end
