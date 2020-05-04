require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "full title helper" do
    assert_equal full_title, "Menu Diary"
    assert_equal full_title("Contact"), "Contact|Menu Diary"
  end
end
