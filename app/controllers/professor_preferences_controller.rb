# app/controllers/professor_preferences_controller.rb
class ProfessorPreferencesController < ApplicationController
    before_action :authorize_admin_or_prof, unless: -> { Rails.env.development? || Rails.env.test? }
  
    def index

        curr_user_id = session[:user_id]
        # @curr_professor = User.find_by(user_id: curr_user_id)

        today = Date.today
        current_year = today.year
        semester = ""
        if today.month >= 8 || today.month < 1
          semester = "Fall #{current_year}"
        elsif today.month >= 1 && today.month <= 5
          semester = "Spring #{current_year}"
        else
          semester = "Summer #{current_year}"
        end
        if semester
          @current_semester = semester
        end
        @projects = Project.where(semester: semester)
        @preference_entities = ProfessorPreference.where(project_id: @projects.pluck(:project_id), professor_id: curr_user_id)
        # puts "[DEBUG] preference_entities: #{@preference_entities.inspect}"
        @project_ranks = {}
        @preference_entities.each do |scores_entity|
          @project_ranks[scores_entity.project_id] = scores_entity.pref
        end
        
        # @professor = @curr_professor.professor  # Get the associated Professor instance
        # @preferences = @professor.professor_preferences.includes(:project)

        # @preferences = ProfessorPreference.find_by()
        # @professor_preferences = @professor.professor_preferences.where(project_id: @projects.pluck(:id))
        # @curr_professor_id = Professor.find_by(email: current_user.email)
        # end
        # @professor_preference = ProfessorPreference.find_by(email: current_user.email)
    end

    def save_rankings
      if Rails.env.test? && defined?(Cucumber)
        curr_user_id = User.find_by(email: 'professor@tamu.edu')
      else
        curr_user_id = session[:user_id]
      end
        project_ranks = params[:project_rank]

        non_blank_ranks = project_ranks.to_unsafe_h.reject { |_, value| value.blank? }

        #make sure that they dont have 2 of the same rank
        if non_blank_ranks.values.group_by { |rank| rank.to_i }.any? { |_, ranks| ranks.length > 1 }
          flash[:error] = "Duplicate ranks found for different projects. Please ensure each project has a unique rank."
          redirect_to prof_projects_ranking_path
          return
        end

        #make sure that the ranks they don't skip any values
        if (1..non_blank_ranks.size).to_a != non_blank_ranks.values.map(&:to_i).sort
          flash[:error] = "Invalid rank sequence. Please ensure ranks are consecutive without skipping any numbers."
          redirect_to prof_projects_ranking_path
          return
        end

        non_blank_ranks.each do |project_id, pref|
          entity = ProfessorPreference.find_by(professor_id: curr_user_id, project_id: project_id)
          # puts "[DEBUG] entity #{entity.inspect}"
          if entity
            ProfessorPreference.where(:professor_id => curr_user_id, :project_id => project_id).update(pref: pref)
          else
            ProfessorPreference.create(professor_id: curr_user_id, project_id: project_id, pref: pref)
          end
        end

        flash[:success] = "Project Preferences saved successfully!"

        redirect_to prof_projects_ranking_path
    end
end
  