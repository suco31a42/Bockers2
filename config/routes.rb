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
  resources :users, only: [:index, :show, :edit, :update] do
      get "search", to: "users#search"
    member do
      get :follows, :followers
    end
      resource :relationships, only: [:create, :destroy]
  end
  resources :groups, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    resource :group_users, only: [:create, :destroy]
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
  end
  resources :chats, only: [:create, :show]



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
