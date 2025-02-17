Rails.application.routes.draw do
  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'

  resources :products

  resource :cart, only: %i[show create update destroy] do
    post 'add_items',  to: 'carts#create', on: :collection
    put 'update_item',  to: 'carts#update', on: :collection
    delete ':product_id', to: 'carts#destroy', as: :delete_item
  end

  get 'up', to: 'rails/health#show', as: :rails_health_check
  root 'rails/health#show'
end
