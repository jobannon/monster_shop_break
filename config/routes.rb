Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'welcome#home'

  resources :merchants

  # get '/merchants', to: "merchants#index"
  # get '/merchants/new', to: "merchants#new"
  # get'/merchants/:id', to: "merchants#show"
  # patch '/merchants/:id/edit', to: 'merchants#edit'
  # post '/merchants', to: 'merchants#create'
  # delete '/merchants/:id', to: 'merchants#destroy' 

  resources :items, except: [:new, :create]

  # get '/items', to: 'items#index'
  # get '/items/:id', to: 'items#show'
  # patch '/items/:id/edit', to: 'items#edit'
  # delete '/items/:id', to: 'items#destroy'
  
  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  # get '/merchants/:merchant_id/items', to: "items#index"
  # get '/merchants/:merchant_id/items/new', to: "items#new"
  # post '/merchants/:merchant_id/items', to: 'items#create'

  resources :items do
    resources :reviews, only: [:new, :create]
  end

  # get '/items/:item_id/reviews/new', to: "reviews#new"
  # post '/items/:item_id/reviews', to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy]

  # get '/reviews/:id/edit', to: 'reviews#edit'
  # patch '/reviews/:id', to: 'reviews#update'
  # delete '/reviews/:id', to: 'reviews#destroy' 

  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/coupon", to: "cart#apply_coupon"
  patch "/cart", to: "cart#increment_decrement"
  patch "/cart/coupon", to: "cart#apply_coupon"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  resources :orders, only: [:new, :create, :show]
  # get '/orders/new', to: 'orders#new'
  # post '/orders', to: "orders#create"
  # get '/orders/:id', to: 'orders#show'

  get '/profile/orders', to: 'orders#index'
  get '/profile/orders/:id', to: 'orders#show'
  patch '/profile/orders/:id', to: 'order_status#update'


  get '/register', to: 'users#new'
  post '/register', to: "users#create"

  get '/user/edit-pw', to: 'user_password#edit'
  patch '/user/edit-pw', to: 'user_password#update'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/profile', to: "sessions#show"

  get "/users/:id/edit", to: "users#edit"
  patch "/users/:id/edit", to: "users#update"

  namespace :admin do
    get '/dashboard', to: 'dashboard#index'
    resources :users, only: [:index, :update, :show]
    # get '/users', to: 'users#index'
    # patch '/users/:id', to: 'users#update'

    get '/merchants/:merchant_id', to: 'merchants#show'
    resources :merchants, only: [:index, :update ]
    # get '/users/:id', to: 'users#show'
    get '/:merchant_id/items', to: 'items#index'
    get '/users/:id/orders', to: 'orders#index'
    patch '/orders/:id', to: 'orders#update'
    get '/users/:id/orders/:id', to: 'orders#show'
    # get '/merchants', to: 'merchants#index'
    # patch '/merchants/:id', to: 'merchants#update'
    get '/merchant/:merchant_id/orders/:order_id', to: 'merchantorders#show'
    patch '/merchantorders/:item_order_id', to: 'merchantorders#update'
    get '/users/:id/edit', to: 'users#edit'
    get '/users/:id/edit-pw', to: 'user_password#edit'
    patch '/users/:id/edit-pw', to: 'user_password#update'
  end

  # get "/merchants/:merchant_id/coupons", to: "coupons#index"

  namespace :merchant do
    get '/dashboard', to: 'dashboard#index'
    get '/orders/', to: 'orders#index'
    patch '/orders/:item_order_id', to: 'orders#update'
    get '/orders/:id', to: 'orders#show'
    get '/items', to: 'items#index'
    patch '/items/:id', to: 'items#update'
    
    resources :coupons, only: [:show, :destroy, :edit, :update, :new, :create] 
    # get '/coupons', to: 'coupons#index'
    # get '/coupons/:id', to: 'coupons#show'
    # delete '/coupons/:id', to: 'coupons#destroy'
    # get '/coupons/:id/edit', to: 'coupons#edit'
    # patch '/coupons/:id', to: 'coupons#update'
    # get '/coupons/new', to: 'coupons#new'
    # post '/coupons', to: 'coupons#create'
  end

  Rails.application.routes.draw do
    match '*path' => 'errors#error_404', via: :all
  end
end
