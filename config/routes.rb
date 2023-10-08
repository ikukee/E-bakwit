Rails.application.routes.draw do
  resources :evacuation_essentials
  resources :relief_goods
  resources :families
  resources :disasters
  resources :evac_centers
  resources :base_records
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to:"main#index"
  get "/detailed_view", to: "main#detailed_view"
  get "/evac_center_form", to: "main#evac_center_form"
  get "/evac_essentials_form/:evac_id/:profile_id", to: "evac_centers#evac_essentials_form"
  get "/evac_facilities_form/:evac_id/:profile_id", to: "evac_centers#evac_facilities_form"
  get "/log_relief_form", to: "main#log_relief_form"
  get "/login", to: "main#login"
  get "/register", to: "main#register"
  get "/log", to: "main#log_evacuee"
  get "/update", to: "main#updateFacilities"
  get "/requestcreate", to: "main#reqCreate"
  get "/logout",to:"main#logout"
  get "/account", to:"main#account"
  get "/requests",to:"volunteer#volunteer_requests"
  get "/families", to: "main#evac_families"
  get "/dashboard",to:"main#index"
  get "/new_user/:id",to:"volunteer#first_login"
  get "/volunteers",to:"volunteer#index"
  get "/download/:id/:img_id/:counter",to:"volunteer#download"
  get "/camp_manager/new",to:"main#new_camp_manager"
  get "/camp_managers",to:"volunteer#camp_managers"

  # base tables
  post "/disasters/search",to:"disasters#search"
  post "/families/search",to:"families#search"
  post "/relief_goods/search",to:"relief_goods#search"
  post "/evacuation_essentials/search",to:"evacuation_essentials#search"
  post "/add_facility",to:"evac_centers#add_facility"
  post "/add_item",to:"evac_centers#add_item"

  
  post "/login/proceed",to:"main#login_proceed"
  post "/send_request",to:"main#send_request_proceed"
  post "/register/camp_manager", to: "main#create_campmanager"
  post "/requests/:id",to:"volunteer#display_request"
  post "/volunteer/:id",to:"volunteer#display_volunteer"
  post "/approve_request/:id",to:"volunteer#approve_request"
  post "/reject_request/:id",to:"volunteer#reject_request"
  post "/change_password",to:"volunteer#change_password"
  post "/add_volunteer",to:"evac_centers#add_volunteer"
  post "/add_campmanager",to:"evac_centers#add_campmanager"
  post "/evac_centers/:id/display_year_profile",to:"evac_centers#display_yearly_profile"
  post "/users/search",to:"volunteer#search"
  post "/evac_centers/search",to:"evac_centers#search"
  post "/families/add_member",to:"families#add_member"
  post "/edit/member/:id" , to:"families#edit_member"
  post "/families/edit_member", to:"families#update_member"
  post  "/remove_campmanager/:id",to:"evac_centers#remove_campmanager"

  delete "/remove_volunteer/:id",to:"evac_centers#remove_volunteer"
  delete "/evac_centers/:id/destroy",to:"evac_centers#destroy"
  delete "/family_member/:id/destroy",to:"families#destroy_member"
  delete "/assigned_essential/:id",to:"evac_centers#destroy_essential"

end
