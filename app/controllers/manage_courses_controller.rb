class ManageCoursesController < ApplicationController
	def index
		@course = Course.pluck(:Semester).uniq
		@selected_semester = params[:semester]

		# @professors = User.includes(:professor => :courses).where.not(professors: { professor_id: nil })
		@professors_for_select = Professor.all.map { |professor| ["#{professor.user.first_name.capitalize} #{professor.user.last_name.capitalize}", professor.id] }


		@courses = if @selected_semester.present?
			Course.where(semester: @selected_semester)
		else
			Course.all
		end
	end

	def edit_courses

		update_professor_assignments if params[:course_assignments].present?
		delete_courses if params[:delete_course].present?

		flash[:success] = "Changes Saved."
		redirect_to manageCourses_path

	end

	private

		def update_professor_assignments
			params[:course_assignments].each do |course_id, professor_id|
				course = Course.find(course_id)
				course.update(professor_id: professor_id)
			end
		end

		def delete_courses
			Course.where(course_id: params[:delete_course]).destroy_all
		end

end