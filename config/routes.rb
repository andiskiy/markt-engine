Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :admin, controller: 'admin' do
    get '/', controller: 'admin/categories', to: 'categories#index'
    resources :categories
    resources :items
    resources :purchases
    resources :users
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :categories
  resources :orders
  resources :items
  resources :carts

  root 'main#index'
end
