Rails.application.routes.draw do
  root 'home#index'

  devise_for :students, controllers: {
    omniauth_callbacks: 'students/omniauth_callbacks',
    sessions: 'students/sessions',
    registrations: 'students/registrations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "profregistration", to: "profregistration#index"
  post "profregistration", to: "profregistration#create"
  get "addProjects", to: "projects#new"
  post "addProjects", to: "projects#create"
  get "projects", to:"projects#index"
  get "/profLanding", to: "prof_landing#index"
  get "StudentForm", to:"studentform#index"
  post "StudentForm", to: "studentform#create"
  # Defines the root path route ("/")
  # root "articles#index"
end