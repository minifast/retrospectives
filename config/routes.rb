Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  resources :boards do
    resources :shares, only: [:show], param: :share_token, module: :boards
    resource :timer, only: [:show, :create, :destroy], module: :boards
    resources :columns, only: [], module: :boards do
      resources :topics, only: [:index, :new, :create, :destroy], module: :columns
    end
  end

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
