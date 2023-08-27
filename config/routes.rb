Rails.application.routes.draw do
  resources :camp_managers
  resources :evac_centers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to:"main#index"
  get "/detailed_view", to: "main#detailed_view"
  get "/evac_center_form", to: "main#evac_center_form"
  get "/evac_facilities_form", to: "main#evac_facilities_form"
  get "/login", to: "main#login"
  get "/dashboard", to: "main#volunteer-dash"
  get "/register", to: "main#register"
  get "/log", to: "main#logEvacuee"
  get "/update", to: "main#updateFacilities"
  get "/requestcreate", to: "main#reqCreate"
  get "/logout",to:"main#logout"

  post "/login/proceed",to:"main#login_proceed"

end
