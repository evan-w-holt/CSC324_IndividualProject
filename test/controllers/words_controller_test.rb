require 'test_helper'

class WordsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @site_title = "Edigaul Abugida"

    @dictionary_url = "/dictionary"
    @word_to_delete = words(:this)
  end

  # Page getting/title tests ==================================================

  test "should get dictionary" do
    get @dictionary_url
    assert_response :success
  end

  test "dictionary page should have dictionary in title" do
    get @dictionary_url
    assert_select "title", "Dictionary | #{@site_title}"
  end

  # Dictionary table tests ==================================================

  test "dictionary should have a row for every word" do
    get @dictionary_url

    num_rows =  Word.all.count
    num_columns = 4

    assert_select "td", num_rows * num_columns

    # Test that the header row contains the right things
    assert_select "th", {:text => "Rohkshe Script", :count => 1}
    assert_select "th", {:text => "English Transliteration", :count => 1}
    assert_select "th", {:text => "English Translation", :count => 1}
  end

  # Dictionary add word tests ==================================================

  test "invalid word should fail" do
    get @dictionary_url

    parameters = {
      word: {
        rohkshe: "invalid",
        transliteration: "invalid",
        translation: "invalid"
      }
    }

    assert_no_difference "Word.count" do
      post @dictionary_url, params: parameters
    end

    assert_template "words/new"
  end

  test "valid word should be added" do
    get @dictionary_url

    parameters = {
      word: {
        rohkshe: "[ih+z+uh]",
        transliteration: "iza",
        translation: "large"
      }
    }

    assert_difference "Word.count", 1 do
      post @dictionary_url, params: parameters
    end

    follow_redirect!
    assert_template "words/index"
  end
  
  # Dictionary delete word tests ==================================================

  test "delete word should delete word" do
    get @dictionary_url

    assert_difference "Word.count", -1 do
      delete word_path(@word_to_delete)
    end

    follow_redirect!
    assert_template "words/index"
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
