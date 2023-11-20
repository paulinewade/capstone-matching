# app/controllers/professor_preferences_controller.rb
class ProfessorPreferencesController < ApplicationController
    before_action :authorize_admin_or_prof
  
    # def index
    #   @preferred_projects = current_professor.preferred_projects
    # end
  
    # def create
    #   project = Project.find(params[:project_id])
    #   current_professor.preferred_projects << project
    #   redirect_to professor_preferences_path
    # end
  
    # def destroy
    #   project = Project.find(params[:project_id])
    #   current_professor.preferred_projects.destroy(project)
    #   redirect_to professor_preferences_path
    # end
    def index
        # puts "Curr user inspect: #{current_user.inspect}"
        # if current_user && current_user.role == "professor"
        # puts params
        @projects = Project.all
        user_id = session[:user_id]
        # puts "session inspect is #{session.inspect}"
        # puts "current user_id is #{user_id}"
        # puts "current user is #{current_user}"
        # puts current_user.inspect
        @curr_professor = User.find_by(user_id: user_id)
        # @curr_professor = User.find_by(email: "profemail@tamu.edu")
        # puts "curr professor #{@curr_professor.inspect}"

        # @curr_prof_id = @curr_professor.user_id
        # puts "curr professor id is #{@curr_prof_id}"

        @professor = @curr_professor.professor  # Get the associated Professor instance
        @preferences = @professor.professor_preferences.includes(:project)

        # @preferences = ProfessorPreference.find_by()
        # @professor_preferences = @professor.professor_preferences.where(project_id: @projects.pluck(:id))
        # @curr_professor_id = Professor.find_by(email: current_user.email)
        # end
        # @professor_preference = ProfessorPreference.find_by(email: current_user.email)
        # puts "Current User Attributes and Values:"
        # current_user.attributes.each do |attr, value|
        #     puts "#{attr}: #{value}"
        # end
        # # Assuming current_user is an instance of your User model
        # puts "Current User Attributes and Values:"
        # puts current_user.inspect
        
        # if current_user && current_user.role == "professor"
        #     # puts("i am a professor")
        #     if current_user.preferred_projects.exclude?(project)
        #         current_user.preferred_projects << project
        #         redirect_to projects_path, notice: "Project added as preferred"
        #       else
        #         redirect_to projects_path, alert: "Project is already in your preferred projects"
        #     end
        # else
        #     # puts("i am not professor")
        #     redirect_to projects_path, alert: "Only professors can mark projects as preferred"
        # end
    end

    def save_rankings
        # @curr_professor = User.find_by(email: "profemail@tamu.edu")
        user_id = session[:user_id]
        @curr_professor = User.find_by(user_id: user_id)
        # puts "curr professor #{@curr_professor.inspect}"

        @professor = @curr_professor.professor  # Get the associated Professor instance
        preferences_params = params[:preferences]
        # puts "professor in save #{@professor}"

        preferences_params.each do |project_id, pref|
            preference = @professor.professor_preferences.find_by(project_id: project_id)
            if preference
              preference.update(pref: pref)
            else
              @professor.professor_preferences.create(project_id: project_id, pref: pref)
            end
        end

        redirect_to profLanding_path, notice: 'Project preferences saved successfully.'
    end
end
  