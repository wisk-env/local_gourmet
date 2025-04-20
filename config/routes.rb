Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  resource :profile, only: %i[show]
  resources :restaurants do
    resources :reviews, except: %i[index] do  
      resource :likes, only: %i[create destroy]
    end
  end
  resources :reviews, only: %i[index] do
    collection do
      get 'search'
    end
  end
  resources :restaurant_registered_statuses, only: %i[index show new]
  resources :restaurant_unregistered_statuses, only: %i[index]
  resources :bookmarks, only: %i[create destroy]
end
