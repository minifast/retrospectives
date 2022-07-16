Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  resources :boards

  resources :columns, only: [], param: :index do
    member do
      delete '(:id)' => "columns#destroy", as: ""
      post '/' => "columns#create"
    end
  end

  root 'boards#index'
end
