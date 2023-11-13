class ManagestudentsController < ApplicationController
    def index
      @students = User.includes(:student).where.not(students: { student_id: nil })
      @courses = Course.all
    end

    def delete_students
      emails = params[:delete_students_emails]

      if emails.nil?
        flash[:error] = "No Students Selected."
        render :index
        return
      end
    
      if emails.present?
        emails.each do |email|
          student = User.find_by(email: email)
    
          if student
            student.destroy
          end
        end
      end

      flash[:success] = "Students Deleted Sucessfully"
      @students = User.includes(:student).where.not(students: { student_id: nil })
      render :index
  end

  def filter_students
    course_id = params[:course_id]
  
    if course_id.present?
      @students = User.includes(student: :course).where(courses: { course_id: course_id})
    else
      @students = User.includes(:student).where.not(students: { student_id: nil })
    end
  
    @courses = Course.all # Fetch all courses for populating the dropdown
    flash[:success] = "Filtered Successfully"
    render :index
  end
  
end