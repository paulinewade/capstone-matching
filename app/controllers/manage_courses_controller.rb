class ManageCoursesController < ApplicationController
	def index
		@course = Course.pluck(:semester).uniq
		@selected_semester = params[:semester]
		@semesters = generate_semesters

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

	def add_course
		@course_number = params[:course_number]
		@section = params[:section]
		@semester = params[:semester_add]
		@professor = params[:professor_id]

		@new_course = Course.new(course_number: @course_number, section: @section, semester: @semester, professor_id: @professor)

		if @new_course.save
			flash[:success] = "Course added successfully."
			redirect_to manageCourses_path
		else
			render :index
		end
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

		def generate_semesters
			current_year = Time.now.year
			semesters = []

			(0..1).each do |year_offset|
				year = current_year + year_offset
				semesters << "Spring #{year}"
				semesters << "Summer #{year}"
				semesters << "Fall #{year}"
			end

			semesters
		end
end