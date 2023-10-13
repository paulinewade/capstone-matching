Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
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
  get "adminlanding", to: "adminlanding#index"
  # Defines the root path route ("/")
  # root "articles#index"
  get '/devtest', to: 'dev_test#index'
  post '/devtest/upload_resume', to: 'dev_test#upload_resume'


end
