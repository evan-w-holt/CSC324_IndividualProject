Rails.application.routes.draw do

  get '/' => 'static_pages#home'
  get '/about' => 'static_pages#about'
  get '/help' => 'static_pages#help'

  resources :tool_pages, :path => '/tool', :only => [:create, :index]

  resources :words, :path => 'dictionary', :only => [:new, :create, :index, :destroy]

  root 'static_pages#home'
end
