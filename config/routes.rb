Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root 'pages#front'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  post 'reviews', to: 'reviews#create'
  get 'my_queue', to: 'queue_items#index'

  resources :videos do
    collection do
      get 'search'
    end
  end
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
end
