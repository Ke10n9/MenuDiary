require 'test_helper'

class MenusRecommendTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "menus recommend" do
    log_in_as(@user)
    # eating_time指定なし
    get recommend_path, params: {eating_time: ""}
    assert_template 'recommended_menus/show'
    assert_match "主菜・丼", response.body
    assert_match "副菜", response.body
    assert_match "汁物", response.body
    for num in 0..4 do
      assert_match "dish_#{num}", response.body
      assert_match "dish_#{num + 15}", response.body
      assert_match "dish_#{num + 30}", response.body
    end
    for num in 0..2 do
      assert_no_match "non_recommend_dish_#{num}", response.body
    end
    # 朝食
    get recommend_path, params: {eating_time: 1}
    for num in 0..14 do
      assert_match "dish_#{3*num}\n", response.body #1,4,...,43は有る
      assert_no_match "dish_#{1 + 3*num}\n", response.body #2, 5,...,44は無い
      assert_no_match "dish_#{2 + 3*num}\n", response.body #3, 6,...,45は無い
    end
    for num in 0..2 do
      assert_no_match "non_recommend_dish_#{num}", response.body
    end
    # 昼食
    get recommend_path, params: {eating_time: 2}
    for num in 0..14 do
      assert_no_match "dish_#{3*num}\n", response.body #1,4,...,43は無い
      assert_match "dish_#{1 + 3*num}\n", response.body #2, 5,...,44は有る
      assert_no_match "dish_#{2 + 3*num}\n", response.body #3, 6,...,45は無い
    end
    for num in 0..2 do
      assert_no_match "non_recommend_dish_#{num}", response.body
    end
    # 夕食
    get recommend_path, params: {eating_time: 3}
    for num in 0..14 do
      assert_no_match "dish_#{3*num}\n", response.body #1,4,...,43は無い
      assert_no_match "dish_#{1 + 3*num}\n", response.body #2, 5,...,44は無い
      assert_match "dish_#{2 + 3*num}\n", response.body #3, 6,...,45は有る
    end
    for num in 0..2 do
      assert_no_match "non_recommend_dish_#{num}", response.body
    end
  end
end
