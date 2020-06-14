require 'test_helper'

class RecommendedMenusControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "should redirect show when not logged in" do
    get recommend_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
