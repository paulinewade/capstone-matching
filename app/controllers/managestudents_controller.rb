class ManagestudentsController < ApplicationController
    before_action :authorize_admin
    def index
      @students = User.includes(:student).where.not(students: { student_id: nil })
      @courses = Course.all
      @ethnicity_names_by_student = {}
  
      @students.each do |user|
        ethnicity_names = user.student.ethnicity_values.pluck(:ethnicity_name)
        @ethnicity_names_by_student[user.user_id] = ethnicity_names
      end
    end

    def delete_students
      emails = params[:delete_students_emails]
      @students = User.includes(:student).where.not(students: { student_id: nil })
      @courses = Course.all
      @ethnicity_names_by_student = {}
  
      @students.each do |user|
        ethnicity_names = user.student.ethnicity_values.pluck(:ethnicity_name)
        @ethnicity_names_by_student[user.user_id] = ethnicity_names
      end

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
      @courses = Course.all
      render :index
  end

  def filter_students
    course_id = params[:course_id]
  
    if course_id.present?
      @students = User.includes(student: :course).where(courses: { course_id: course_id})
    else
      @students = User.includes(:student).where.not(students: { student_id: nil })
    end

    @ethnicity_names_by_student = {}
  
    @students.each do |user|
      ethnicity_names = user.student.ethnicity_values.pluck(:ethnicity_name)
      @ethnicity_names_by_student[user.user_id] = ethnicity_names
    end
  
    @courses = Course.all # Fetch all courses for populating the dropdown
    flash[:success] = "Filtered Successfully"
    render :index
  end

  private
      def authorize_admin
          curr_user_id = session[:user_id]
          # print "[DEBUG] curr_user_id: #{curr_user_id}"
          if curr_user_id
              curr_user_role = User.find_by(user_id: curr_user_id).role
              # print "[DEBUG] curr_user_role: #{curr_user_role}"
              if curr_user_role != "admin"
                  flash[:error] = 'Access Denied'
                  redirect_to root_path
              end
          else
              flash[:error] = 'Access Denied'
              redirect_to root_path
          end
      end
  
end