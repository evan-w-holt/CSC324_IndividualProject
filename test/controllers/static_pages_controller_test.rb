require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
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

  # Home page random word tests ==================================================

  test "random word table should not be empty" do
    get @home_url

    assert_select "td", 6
    assert_select "td", {:text=>"Rohkshe", :count=>1}
    assert_select "td", {:text=>"English Transliteration", :count=>1}
    assert_select "td", {:text=>"English Translation", :count=>1}
  end

end
