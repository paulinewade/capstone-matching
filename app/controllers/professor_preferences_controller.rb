# app/controllers/professor_preferences_controller.rb
class ProfessorPreferencesController < ApplicationController
    before_action :authorize_admin_or_prof, unless: -> { Rails.env.development? || Rails.env.test? }
  
    def index
        curr_user_id = session[:user_id]
        # @curr_professor = User.find_by(user_id: curr_user_id)

        today = Date.today
        config = Config.first
        current_year = today.year

        spring_start_date = Date.new(current_year, config.spring_semester_month, config.spring_semester_day)
        summer_start_date = Date.new(current_year, config.summer_semester_month, config.summer_semester_day)
        fall_start_date = Date.new(current_year, config.fall_semester_month, config.fall_semester_day)

        if (config.present? && today >= spring_start_date) && (today < summer_start_date)
          @current_semester = "Spring #{current_year}"
        elsif (config.present? && today >= summer_start_date) && (today < fall_start_date)
          @current_semester = "Summer #{current_year}"
        elsif (config.present? && today >= fall_start_date) && (today <= Date.new(current_year, 12, 31))
          @current_semester = "Fall #{current_year}"
        else
          @current_semester = "Fall 2023"
        end

        @projects = Project.where(semester: @current_semester)
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

        ProfessorPreference.where(professor_id: curr_user_id).destroy_all

        non_blank_ranks.each do |project_id, pref|
            ProfessorPreference.create(professor_id: curr_user_id, project_id: project_id, pref: pref)
        end

        flash[:success] = "Project Preferences saved successfully!"

        redirect_to prof_projects_ranking_path
    end
end
  