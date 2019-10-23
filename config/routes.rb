Rails.application.routes.draw do

  get '/' => 'static_pages#home'
  get '/about' => 'static_pages#about'
  get '/help' => 'static_pages#help'

  resources :words, :path => 'dictionary', :only => [:new, :create, :index, :show]

  root 'static_pages#home'
end
