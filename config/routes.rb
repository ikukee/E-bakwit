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
  get "/evac_essentials_form/:evac_id/:profile_id", to: "evac_centers#evac_essentials_form"
  get "/evac_facilities_form/:evac_id/:profile_id", to: "evac_centers#evac_facilities_form"
  get "/evac_centers/show/archives",to:"evac_centers#archives"
  get "/log_relief_form", to: "main#log_relief_form"
  get "/login", to: "main#login"
  get "/register", to: "main#register"
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

  ## GENERATION OF REPORT

  get "evac_centers/:evac_center/:disaster_id/generate", to: "generate_report#generate"
  get "disasters/:disaster_id/generate", to: "generate_report#generate_all"
  ## LOGGING
  
  get "evac_centers/:id/log/:disaster_id", to: "log_family#logging"
  get "evac_centers/:evac_id/:disaster_id/evacuated", to: "log_family#evacuatedView"
  post "evac_centers/:evac_id/:disaster_id/out/:member_id", to: "log_family#evacueeOut"
  post "evac_centers/:evac_id/:disaster_id/released/:member_id", to: "log_family#evacueeReleased"
  post "/evac_centers/:id/archive",to:"evac_centers#archive_center"
  post "/evac_centers/:id/unarchive",to:"evac_centers#unarchive_center"
  post "/view_evacuated_family", to: "log_family#view_evacuated_family"
  post "log/search",to:"log_family#search"
  post "/log/:member_id/:evac_id/:disaster_id", to: "log_family#evacuate"
  post "/log/all/:family_id",to:"log_family#evacuate_all"
  post "/view_disaster_evacuation",to: "evac_centers#view_disaster_evacuation"

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
  post "/add_new_profile/:id",to:"evac_centers#add_profile"


  #RELIEF GOOD ALLOCATION
  get "/relief_good/requests",to:"relief_allocation#relief_request"
  get "/relief_good/accepted_requests",to:"relief_allocation#accepted_request"
  get "/dispatch/request/:id",to: "relief_allocation#allocation"
  get "/relief_good/dispatched_requests",to:"relief_allocation#dispatched_request"
  get "/relief_allocation/:evac_id/:disaster_id", to: "relief_allocation#your_request"
  get "/relief_allocation/configuration/:evac_id/:disaster_id", to: "relief_allocation#configuration"
  get "/relief_allocation/storage/:evac_id/:disaster_id",to: "relief_allocation#storage"
  get "/evac_centers/distributed_rg/:evac_id/:disaster_id", to:"relief_allocation#distributed_rg"
  get "/evac_centers/non_distributed_rg/:evac_id/:disaster_id", to:"relief_allocation#non_distributed_rg"
  get "/view/evacuee/members/:id/:method", to:"relief_allocation#view_evac_members"

  post "/send/relief/:evac_id/:disaster_id",to:"relief_allocation#send_request"
  post "/view/request/:id",to:"relief_allocation#view_request"
  post "/approve/request/:id",to:"relief_allocation#approve_request"
  post "/allocate_rg",to:"relief_allocation#allocate_rg"
  post "/edit_rg/:rg_id/:request_id",to:"relief_allocation#edit_rg"
  post "/dispatch/request/:id",to: "relief_allocation#dispatch_request"
  post "/mark_received/request/:id",to:"relief_allocation#receive_request"
  post "/sort_by", to: "relief_allocation#sort_by"
  post "/sort_by/type", to: "relief_allocation#sort_by_type"
  post "/sort_by/search", to: "relief_allocation#sort_by_search"
  post "/show/configurations", to:"relief_allocation#show_configurations"
  post "/save/configuration/:id",to:"relief_allocation#save_configuration"
  post "/distribute/relief_goods/:id", to:"relief_allocation#distribute_goods"
  post "/view/allocated_rgs", to:"relief_allocation#view_allocated_rgs"
  post "/search/evacuees", to:"relief_allocation#search_evacuees"
  

  delete "/remove_volunteer/:id",to:"evac_centers#remove_volunteer"
  delete "/evac_centers/:id/destroy",to:"evac_centers#destroy"
  delete "/family_member/:id/destroy",to:"families#destroy_member"
  delete "/assigned_essential/:id",to:"evac_centers#destroy_essential"

end
