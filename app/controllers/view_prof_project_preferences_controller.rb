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
	end

	def update_professor_preferences
		project_id = params[:project_id]
		professor_id = params[:professor_id]
		commit_type = params[:commit_type]

		if project_id.present? && commit_type.present?
			if commit_type == 'Assign' && professor_id.present?
				existing_preference = ProfessorPreference.find_by(project_id: project_id, professor_id: professor_id)

				if existing_preference
					# Update the existing preference if it already exists
					existing_preference.update(pref: params[:rank])  # Update other attributes as needed
					flash[:success] = "Professor assignment already exits."
				else
					# Create a new preference if it doesn't exist
					if params[:rank].present?
						rank = params[:rank]
					else
						rank = 0
					end
					ProfessorPreference.create(professor_id: professor_id, project_id: project_id, pref: rank)
					flash[:success] = "Professor assigned successfully."
				end
			elsif commit_type == 'Delete'
				# Delete selected professors from project preferences
				professor_ids = params[:professor_ids]
				if professor_ids.present?
					ProfessorPreference.where(professor_id: professor_ids).destroy_all
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