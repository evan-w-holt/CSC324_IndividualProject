Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/reading_writing'
  get 'static_pages/help'

  root 'application#homePage'
end
