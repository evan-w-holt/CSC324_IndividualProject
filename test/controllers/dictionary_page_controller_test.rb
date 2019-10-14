require 'test_helper'

class DictionaryPageControllerTest < ActionDispatch::IntegrationTest

  def setup
    @dictionary_url = "/dictionary"
  end

  # Page getting tests ==================================================

  test "should get dictionary" do
    get @dictionary_url
    assert_response :success
  end

  # Dictionary table tests ==================================================

  test "dictionary should have a row for every word" do
    get @dictionary_url

    num_rows =  Word.all.count + 1 # plus 1 for the header row
    num_columns = 3

    assert_select "td", num_rows * num_columns

    # Test that the header row contains the right things
    assert_select "td", {:text => "Rohkshe Script", :count => 1}
    assert_select "td", {:text => "English Transliteration", :count => 1}
    assert_select "td", {:text => "English Translation", :count => 1}
  end

  # Dictionary page edigaul tests ==================================================

  test "each edigaul text box should contain at least one edigaul word" do
    get @home_url

    assert_select "span.edigaulTextBox" do |elements|
      elements.each do |element|
        assert_select element, "span.edigaulWord", :minimum => 1
      end
    end
  end

  test "each edigaul word should contain at least one edigaul unit" do
    get @home_url

    assert_select "span.edigaulWord" do |elements|
      elements.each do |element|
        assert_select element, "span.edigaulUnit", :minimum => 1
      end
    end
  end

  test "each edigaul unit should contain between one and three img" do
    get @home_url

    assert_select "span.edigaulUnit" do |elements|
      elements.each do |element|
        assert_select element, "img", {:minimum => 1, :maximum => 3}
      end
    end
  end
end
