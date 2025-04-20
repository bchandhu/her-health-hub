Rails.application.routes.draw do
  get 'pages/home'

  devise_for :users

  resources :logs
  resources :diagnostics
  get "/dashboard", to: "pages#dashboard", as: "dashboard"
  

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"

  
end
