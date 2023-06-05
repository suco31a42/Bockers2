Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  root to: 'homes#top'
  
  get 'home/about' => 'homes#about', as:'about'

  resources :books, only: [:index, :show, :edit, :update, :create, :destroy] do
    resource :favorites, only: [:create,:destroy]
  end
  resources :users, only: [:index, :show, :edit, :update]
  resources :groups, only: [:index, :new, :create, :show, :edit, :update, :destroy]



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
