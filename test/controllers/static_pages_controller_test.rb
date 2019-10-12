require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    Rails.application.load_seed

    @site_title = "Edigaul Abugida"

    @home_url = "/"
    @help_url = "/help"
    @about_url = "/about"
  end

  # Page getting tests ==================================================

  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get home" do
    get @home_url
    assert_response :success
  end

  test "should get help" do
    get @help_url
    assert_response :success
  end

  test "should get about" do
    get @about_url
    assert_response :success
  end

  # Page title tests ==================================================

  test "root page should have home in title" do
    get root_url
    assert_select "title", "Home | #{@site_title}"
  end

  test "home page should have home in title" do
    get @home_url
    assert_select "title", "Home | #{@site_title}"
  end

  test "help page should have help in title" do
    get @help_url
    assert_select "title", "Help | #{@site_title}"
  end

  test "about page should have about in title" do
    get @about_url
    assert_select "title", "About | #{@site_title}"
  end

  # Home page random word table tests ==================================================

  test "random word table should exist with headers" do
    get @home_url

    assert_select "td", 6
    assert_select "td", {:text => "Rohkshe", :count => 1}
    assert_select "td", {:text => "English Transliteration", :count => 1}
    assert_select "td", {:text => "English Translation", :count => 1}
  end

  # Home page edigaul tests ==================================================

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
