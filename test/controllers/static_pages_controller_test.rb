require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | Edigaul Abugida"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | Edigaul Abugida"
  end

  test "should get reading writing" do
    get static_pages_reading_writing_url
    assert_response :success
    assert_select "title", "Reading and Writing in Edigaul | Edigaul Abugida"
  end

end
