Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resource :profile, only: %i[show]
  resources :restaurants do
    resources :reviews, only: %i[show new create]
  end
  resources :restaurant_registered_statuses, only: %i[index show new]
  resources :restaurant_unregistered_statuses, only: %i[index]
  resources :bookmarks, only: %i[create destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Defines the root path route ("/")
  # root "posts#index"
end
