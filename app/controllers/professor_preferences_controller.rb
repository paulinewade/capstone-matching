# app/controllers/professor_preferences_controller.rb
class ProfessorPreferencesController < ApplicationController
    # before_action :authenticate_professor!
  
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
    def add_preferred
        # puts(current_user)
        project = Project.find(params[:id])
        # puts "Current User Attributes and Values:"
        # current_user.attributes.each do |attr, value|
        #     puts "#{attr}: #{value}"
        # end
        # # Assuming current_user is an instance of your User model
        # puts "Current User Attributes and Values:"
        # puts current_user.inspect
        
        if current_user && current_user.role == "professor"
            # puts("i am a professor")
            if current_user.preferred_projects.exclude?(project)
                current_user.preferred_projects << project
                redirect_to projects_path, notice: "Project added as preferred"
              else
                redirect_to projects_path, alert: "Project is already in your preferred projects"
            end
        else
            # puts("i am not professor")
            redirect_to projects_path, alert: "Only professors can mark projects as preferred"
        end
    end
  end
  