Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users, only: [:show, :edit, :update] do
    match 'finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup, on: :member
  end
  
  # root 'charities#index'
  resources :charities
end
