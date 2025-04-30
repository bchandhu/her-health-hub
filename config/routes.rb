Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  get "/dashboard", to: "pages#dashboard", as: "dashboard"

  resources :logs

  resources :diagnostics do
    collection do
      post :start_new_diagnostic
      get :report 
    end
    resources :wizard, controller: 'diagnostics/wizard'
  end
end
