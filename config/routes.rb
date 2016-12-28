Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root 'pages#front'
  get '/home', to: 'videos#index'
  resources :videos do
    collection do
      get 'search'
    end
  end

  get '/register', to: 'users#new'
  resources :users, only: [:create]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
end
