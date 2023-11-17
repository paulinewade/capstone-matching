class ManageCoursesController < ApplicationController
	def index
		@course = Course.pluck(:Semester).uniq
		@selected_semester = params[:semester]

		@courses = if @selected_semester.present?
			Course.where(semester: @selected_semester)
		else
			Course.all
		end
	end

	def edit_courses
	end
end