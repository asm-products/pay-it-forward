Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  match 'users/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :user_finish_signup
  resources :users, only: [:show]
  
  resources :charities
  get "/pages/*id" => 'pages#show', as: :page, format: false
  root to: 'pages#show', id: 'instructions'
end
