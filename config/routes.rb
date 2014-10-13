Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  match 'users/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :user_finish_signup
  resources :users, only: [:show]
  
  # root 'charities#index'
  resources :charities
end
