Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "profregistration", to: "profregistration#index"
  post "profregistration", to: "profregistration#create"
  get "addProjects", to: "projects#new"
  post "addProjects", to: "projects#create"
  get "projects", to:"projects#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
