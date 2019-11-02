require 'test_helper'

class ToolPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tool_pages_index_url
    assert_response :success
  end

end
