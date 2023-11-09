Rails.application.routes.draw do
  root 'home#index'

  get '/auth/google_oauth2', as: 'google_login'
  get '/auth/google_oauth2/callback', to: 'sessions#google_auth'
  get '/logout', to: 'sessions#destroy'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "profregistration", to: "profregistration#index"
  post "profregistration", to: "profregistration#create"

  get "addProjects", to: "projects#new"
  post "addProjects", to: "projects#create"

  get "/profLanding", to: "prof_landing#index"

  get "studentform", to:"studentform#index"
  post "studentform", to: "studentform#create"

  get "adminlanding", to: "adminlanding#index"

  get "manageprof", to: "manageprof#index"
  post '/manageprof/save_change', to: 'manageprof#save_change', as: 'save_change'
  post '/manageprof/add_professor', to: 'manageprof#add_professor', as: 'add_professor'

  get "lock_unlock_form", to: "adminlanding#lock_unlock_form"
  post "lock_unlock", to: "adminlanding#lock_unlock", as: :lock_unlock
  post 'lock_unlock_all_students', to: 'adminlanding#lock_unlock_all_students', as: 'lock_unlock_all_students'

  get "managestudents", to: "managestudents#index"
  get "/managestudents/filter_students", to: "managestudents#filter_students", as: "filter_students"
  post '/managestudents/delete_students', to: 'managestudents#delete_students', as: 'delete_students'

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
    end
  end
  
  get 'prof_projects_ranking', to: 'professor_preferences#index'
  post 'prof_projects_ranking', to: 'professor_preferences#save_rankings'

end
