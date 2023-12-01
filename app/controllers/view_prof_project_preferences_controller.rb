class ViewProfProjectPreferencesController < ApplicationController
	def index
		@project_names = Project.pluck(:name)
		@selected_project = params[:project]

		@projects = if @selected_project.present?
			Project.where(name: @selected_project)
		else
			Project.all
		end

	    @professor_preferences = ProfessorPreference.where(project_id: @projects.pluck(:project_id))

		@courses_by_semester = {}

		Course.all.each do |course|
			next if course.professor_id.nil?

			semester = course.semester
			@courses_by_semester[semester] ||= [] # Initialize the array if it doesn't exist
			@courses_by_semester[semester] << course
		end
	end

	def update_professor_preferences
		project_id = params[:project_id]
		course_id = params[:course_id]
		commit_type = params[:commit_type]

		if project_id.present? && commit_type.present?
			if commit_type == 'Assign' && course_id.present?
				project = Project.find_by(project_id: project_id)
				project.update(course_id: course_id)
				flash[:success] = "Professor assigned successfully."
			elsif commit_type == 'Assign' && !course_id.present?
				project = Project.find_by(project_id: project_id)
				project.update(course_id: nil)
				flash[:success] = "Professor unassigned successfully."
			elsif commit_type == 'Delete'
				# Delete selected professors from project preferences
				professor_ids = params[:professor_ids]
				if professor_ids.present?
					ProfessorPreference.where(professor_id: professor_ids, project_id: project_id).destroy_all
					flash[:success] = "Selected professors deleted successfully."
				else
					flash[:error] = "No professors selected for deletion."
				end
			else
				flash[:error] = "Invalid professor or action."
			end
		else
			flash[:error] = "Invalid project or action."
		end

		redirect_to view_prof_project_preferences_path
	end

end