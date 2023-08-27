Rails.application.routes.draw do
  resources :camp_managers
  resources :evac_centers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to:"main#index"
  get "/detailed_view", to: "main#detailed_view"
  get "/evac_center_form", to: "main#evac_center_form"
  get "/evac_essentials_form", to: "main#evac_essentials_form"
  get "/evac_facilities_form", to: "main#evac_facilities_form"
  get "/log_relief_form", to: "main#log_relief_form"
  get "/login", to: "main#login"
  get "/dashboard", to: "main#volunteer-dash"
  get "/register", to: "main#register"
  get "/log", to: "main#logEvacuee"
  get "/update", to: "main#updateFacilities"
  get "/requestcreate", to: "main#reqCreate"
  get "/logout",to:"main#logout"
  get "/families", to: "main#detailed_evacuees"
  delete "/evac_centers/:id/destroy",to:"evac_centers#destroy"

  post "/login/proceed",to:"main#login_proceed"

end
