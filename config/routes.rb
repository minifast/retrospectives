Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  resources :boards
  root 'boards#index'
  devise_scope :user do
    namespace :users, as: :user do
      resource :session, only: [:destroy]
    end
  end
end
