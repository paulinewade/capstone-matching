class ManagestudentsController < ApplicationController
    def index
      @students = User.includes(:student).where.not(students: { student_id: nil })
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
end