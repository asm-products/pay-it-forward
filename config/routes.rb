Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  match 'users/finish_sign_up' => 'users#finish_sign_up', via: [:get, :patch], :as => :user_finish_sign_up
  resources :users, only: [:show]
  
  resources :charities
  get "/pages/*id" => 'pages#show', as: :page, format: false
  root to: 'pages#show', id: 'instructions'
end
