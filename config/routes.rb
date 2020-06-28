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

  get '/recommend', to: 'recommended_menus#show'

  resources :meals, only: [:create, :destroy, :edit, :update]
  resources :dishes, only: [:create, :destroy, :edit, :update]
  resources :menus, only: [:create, :destroy, :edit, :update]

end
