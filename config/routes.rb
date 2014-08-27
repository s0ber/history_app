require 'routing_filters/helper_params'

Rails.application.routes.draw do
  filter :helper_params

  root 'pages#root'
  get 'dashboard' => 'pages#dashboard'
  get 'search' => 'search#index'
  get 'about' => 'pages#about'

  resources :items, only: [:show]
end
