Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  get "/dashboard", to: "pages#dashboard", as: "dashboard"

  resources :logs

  resources :diagnostics do
    member do
      get :report
    end
    collection do
      post :start_new_diagnostic
    end
    resources :wizard, controller: 'diagnostics/wizard'
  end
end
