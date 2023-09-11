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
  get "/requests",to:"volunteer#volunteer_requests"
  get "/distribution", to: "main#reliefdist"
  get "/families", to: "main#evac_families"
  get "/dashboard",to:"main#index"
  get "/new_user/:id",to:"volunteer#first_login"
  get "/volunteers",to:"volunteer#index"
  get "/disasters", to: "disasters#index"
  get "/disasters/new", to: "disasters#new"
  get "/disasters/show", to: "disasters#show"


  # base tables
  get "/base", to: "base_records#index"
  get "/base/disaster_form", to: "base_records#disaster_form"
  get "/base/relief_form", to:"base_records#relief_form"
  get "/base/family_form", to:"base_records#family_form"

  
  

  post "/login/proceed",to:"main#login_proceed"
  post "/send_request",to:"main#send_request_proceed"
  post "/requests/:id",to:"volunteer#display_request"
  post "/volunteer/:id",to:"volunteer#display_volunteer"
  post "/approve_request/:id",to:"volunteer#approve_request"
  post "/reject_request/:id",to:"volunteer#reject_request"
  post "/change_password",to:"volunteer#change_password"
  post "/add_volunteer",to:"evac_centers#add_volunteer"

  post "/evac_centers/:id/display_year_profile",to:"evac_centers#display_yearly_profile"
  post "/volunteers/search",to:"volunteer#search_volunteers"
  post "/evac_centers/search",to:"evac_centers#search"
  delete "/remove_volunteer/:id",to:"evac_centers#remove_volunteer"
  delete "/evac_centers/:id/destroy",to:"evac_centers#destroy"
end
