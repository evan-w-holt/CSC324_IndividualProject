class ApplicationController < ActionController::Base
  def homePage
    redirect_to static_pages_home_url
  end
end
