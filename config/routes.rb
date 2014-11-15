Rails.application.routes.draw do

  resources :pledges
  resources :charities
  
  # Pages
  get "/pages/*id" => 'pages#show', as: :page, format: false
  root to: 'pages#show', id: 'index'
end
