Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :hr do
    post 'sign_in'
  end

  namespace :home do
    get 'index'
    post 'webhook'
  end

  root 'home#index'
end
