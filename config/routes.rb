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

  get "/profLanding", to: "prof_landing#index"
  get "StudentForm", to:"studentform#index"
  post "StudentForm", to: "studentform#create"
  get "adminlanding", to: "adminlanding#index"
  get "manageprof", to: "manageprof#index"
  post '/manageprof/save_change', to: 'manageprof#save_change', as: 'save_change'
  post '/manageprof/add_professor', to: 'manageprof#add_professor', as: 'add_professor'

  get "open_close_student_form", to: "adminlanding#open_close_student_form"
  post "open_close_student_form", to: "adminlanding#update_open_close_student_form"

  # Defines the root path route ("/")
  # root "articles#index"
  get '/devtest', to: 'dev_test#index'
  post '/devtest/upload_resume', to: 'dev_test#upload_resume'
  resources :sections, only: [:new, :create]
  get 'changeweights', to: 'changeweights#index'
  post 'changeweights/save_weights', to: 'changeweights#save_weights', as: 'save_weights'
  # get 'dev_test/classify', to: 'dev_test#classify'
  resources :projects do
    member do
      get "projects", to:"projects#index"
      delete "projects/:id", to:"projects#destroy"
    end
  end


  resources :projects do
    member do
      get "projects", to:"projects#index"
      delete "projects/:id", to:"projects#destroy"
      post 'add_preferred', to: 'professor_preferences#add_preferred'
    end
  end


end
