Rails.application.routes.draw do
  get 'sign_in' => 'user_sessions#new', as: :new_user_session
  post 'sign_in' => 'user_sessions#create', as: :user_session
  get 'sign_out' => 'user_sessions#destroy', as: :destroy_user_session
  post 'sign_out' => 'user_sessions#destroy', as: nil

  resource :user, only: [:new, :create]
  resources :pledges do
    post 'new' => 'pledges#new', on: :collection, as: nil
  end
  resources :charities

  # Pages
  get '/pages/*id' => 'pages#show', as: :page, format: false
  root to: 'pages#show', id: 'index'

  namespace :fragments do
    get :pledge_form, action: 'pledge_form'
  end
end
