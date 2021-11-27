Rails.application.routes.draw do

  root to: 'pages#home'
  devise_for :users, controllers: {registrations: "registrations"}
  get "role", to: "pages#role"

  resources :articles

  get '*path' => redirect('/')
end