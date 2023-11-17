Rails.application.routes.draw do
  resources :reviews
  devise_for :users
  # Defines the root path route ("/")
  root "reviews#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
