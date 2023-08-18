Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to:"main#index"
  get "/detailed_view", to: "main#detailed_view"
  get "/evac_center_form", to: "main#evac_center_form"
  get "/login", to: "main#login"
  get "/dashboard", to: "main#volunteer-dash"
  get "/update", to: "main#updateFacilities"
end
