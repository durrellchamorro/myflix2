Myflix::Application.routes.draw do
  mount ImageUploader::UploadEndpoint => "/images"

  get 'ui(/:action)', controller: 'ui'
  root 'pages#front'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get '/login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  post 'reviews', to: 'reviews#create'
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  get 'people', to: 'relationships#index'

  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:create]
  get 'password_reset/:token', to: 'password_resets#show', as: 'password_reset'
  get 'expired_token', to: 'pages#expired_token', as: 'expired_token'

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :videos do
    collection do
      get 'search'
    end
  end
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  resources :users, only: [:show]
  resources :categories, only: [:show]
  resources :relationships, only: [:destroy, :create]
  resources :invitations, only: [:new, :create]
end
