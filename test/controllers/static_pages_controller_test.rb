require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_path
    assert_response :success
    assert_select "title", "Menu Diary"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact|Menu Diary"
  end

  # test "should get help" do
  #   get static_pages_help_url
  #   assert_response :success
  #   assert_select "title", "Help|Task Management App"
  # end
  #
  # test "should get about" do
  #   get static_pages_about_url
  #   assert_response :success
  #   assert_select "title", "About|Task Management App"
  # end

end
