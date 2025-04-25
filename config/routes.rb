Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  get "/dashboard", to: "pages#dashboard", as: "dashboard"

  resources :diagnostics
  resources :logs
end

