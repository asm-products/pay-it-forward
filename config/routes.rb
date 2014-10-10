Rails.application.routes.draw do
  
  devise_for :users
  #root 'charities#index'
  resources :charities

end
