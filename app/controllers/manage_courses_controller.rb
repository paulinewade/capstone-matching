class ManageCoursesController < ApplicationController
	def index
		@courses = Course.pluck(:Semester).uniq
		@selected_semester = params[:semester]

		@course = if @selected_semester.present?
			Course.where(Semester: @selected_semester)
		else
			Course.all
		end
	end
end