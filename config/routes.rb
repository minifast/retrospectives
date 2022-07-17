Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  resources :boards
  devise_scope :user do
    namespace :users, as: :user do
      resource :session, only: [:destroy]
    end
  end

  authenticated :user do
    root to: 'boards#index', as: :user_root
  end

  root to: 'landings#show'
end
