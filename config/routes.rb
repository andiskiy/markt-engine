Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :admin, controller: 'admin' do
    get '/', controller: 'admin/categories', to: 'categories#index'
    resources :categories do
      resources :items
    end
    get :items, controller: 'admin/items', to: 'items#all_items'
    resources :purchases, only: %i[index destroy] do
      post :complete
      resources :orders, only: :index
    end
    resources :users
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :categories
  resources :orders
  resources :items, only: :index
  resources :carts
  resources :purchases, only: :update

  root 'main#index'
end
