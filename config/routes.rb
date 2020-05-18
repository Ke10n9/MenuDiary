Rails.application.routes.draw do

  get 'sessions/new'
  root 'static_pages#home'
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :meals, only: [:create, :destroy]
  resources :dishes, only: [:create, :destroy]
  resources :menus, only: [:create, :destroy]

end
