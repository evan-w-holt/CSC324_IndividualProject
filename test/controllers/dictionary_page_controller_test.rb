require 'test_helper'

class DictionaryPageControllerTest < ActionDispatch::IntegrationTest

  def setup
    Rails.application.load_seed

    @dictionary_url = "/dictionary"
  end

  # Page getting tests ==================================================

  test "should get dictionary" do
    get @dictionary_url
    assert_response :success
  end

  # Dictionary table tests ==================================================

end
