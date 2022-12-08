Rails.application.routes.draw do
  resources :customers
  resources :bills
  resources :products

  get '/display_bills', to: 'customers#display_bills'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
