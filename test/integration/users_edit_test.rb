require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select "div.alert", "送信した内容に3つエラーがあります。"
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    session[:forwarding_url] = edit_user_url(@user)
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    name = "Foo Bar"
    patch user_path(@user), params: { user: { name: name,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
  end
end
