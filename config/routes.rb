Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :admin, controller: 'admin' do
    get '/', controller: 'admin/categories', to: 'categories#index'
    resources :categories do
      get :move_items
      patch :update_items
      resources :items
    end
    get :items, controller: 'admin/items', to: 'items#all_items'
    resources :purchases, only: %i[index destroy] do
      post :complete
      resources :orders, only: :index
    end
    resources :users, except: %i[edit new create]
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get :my_account, to: 'users/registrations#show', as: 'my_account'
  end

  resources :categories, only: :show
  resources :orders, only: %i[create destroy]
  resources :items, only: %i[index show]
  resources :carts, only: :index
  resources :purchases, only: %i[edit update]

  root 'items#index'
end
