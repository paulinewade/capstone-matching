Rails.application.routes.draw do
	get 'sponsor_restrictions/edit'
	get 'sponsor_restrictions/new'
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

  get "configuration", to: "adminlanding#configuration"
  post "update_configuration", to: "adminlanding#update_configuration"
  
	get "open_close_student_form", to: "adminlanding#open_close_student_form"
	post "open_close_student_form", to: "adminlanding#update_open_close_student_form"

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
		resources :sponsor_restrictions
		resources :sponsor_preferences
	end


  resources :projects do
    member do
      get "projects", to:"projects#index"
      delete "projects/:id", to:"projects#destroy"
    end
  end

  get 'prof_projects_ranking', to: 'professor_preferences#index'
  post 'prof_projects_ranking', to: 'professor_preferences#save_rankings'

  post 'dump_database', to: 'database_dump#dump_database'

  get 'view_results', to: 'results#index', as: 'results'
  get 'results_export/:semester/:project.csv', to: 'results#export', as: 'results_export'

  get "manageCourses", to: "manage_courses#index"
  post "manageCourses/edit_courses", to: "manage_courses#edit_courses", as: "edit_courses"
	post "manageCourses/add_course", to: "manage_courses#add_course", as: "add_course"

	get "viewProfProjectPreferences", to: "view_prof_project_preferences#index"
	post '/update_professor_preferences', to: 'view_prof_project_preferences#update_professor_preferences', as: 'update_professor_preferences'
	resources :view_prof_project_preferences do
		post 'assign_professor', on: :collection
	end

end
