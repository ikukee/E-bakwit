Rails.application.routes.draw do
  resources :camp_managers
  resources :evac_centers
  resources :base_records
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to:"main#index"
  get "/detailed_view", to: "main#detailed_view"
  get "/evac_center_form", to: "main#evac_center_form"
  get "/evac_essentials_form", to: "main#evac_essentials_form"
  get "/evac_facilities_form", to: "main#evac_facilities_form"
  get "/log_relief_form", to: "main#log_relief_form"
  get "/login", to: "main#login"
  get "/register", to: "main#register"
  get "/log", to: "main#log_evacuee"
  get "/update", to: "main#updateFacilities"
  get "/requestcreate", to: "main#reqCreate"
  get "/logout",to:"main#logout"
  get "/requests",to:"main#volunteer_requests"
  get "/distribution", to: "main#reliefdist"
  get "/families", to: "main#evac_families"
  delete "/evac_centers/:id/destroy",to:"evac_centers#destroy"

  post "/login/proceed",to:"main#login_proceed"
  post "/send_request",to:"main#send_request_proceed"

end
