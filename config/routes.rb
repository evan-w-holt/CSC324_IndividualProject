Rails.application.routes.draw do

  get '/' => 'static_pages#home'
  get '/about' => 'static_pages#about'
  get '/help' => 'static_pages#help'

  get '/dictionary' => 'dictionary_page#dictionary'
  post '/dictionary' => 'dictionary_page#create'

  root 'static_pages#home'
end
