Rails.application.routes.draw do
  root 'pages#root'
  get 'dashboard' => 'pages#dashboard'
  get 'search' => 'search#index'
  get 'about' => 'pages#about'

  resources :items, only: [:show]
end
