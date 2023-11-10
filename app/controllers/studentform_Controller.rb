class StudentformController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @courses = Course.select(:id, :course_number, :section, :semester).distinct
  end

  def create
    # Extract form parameters
    email = params[:email]
    first_name = params[:first_name]
    last_name = params[:last_name]
    uin = params[:uin]
    gender = params[:gender]

    if email.end_with?("tamu.edu")
      existing_student = User.find_by(email: email)

      if existing_student
        flash[:error] = "You are already registered using this email."
      else
        # Create a new student
        new_student = User.new(email: email, first_name: first_name, last_name: last_name, role: "student")

        # Save the student to get an ID and use that ID for the student record
        if new_student.save
          # Create a student record associated with the user
          id = new_student.user_id
          student = Student.new(
            student_id: id,
            course_id: 1, # you need to extract course_id from the form parameters
            gender: gender,
            nationality: params[:nationality], # extract other parameters as needed
            work_auth: params[:work_authorization],
            contract_sign: "No",
            resume: "After resume parsing"
          )

          if student.save
            flash[:success] = "Registration Successful!"
          else
            flash[:error] = "Failed to save student information."
          end
        else
          flash[:error] = "Failed to save user information."
        end
      end
    else
      flash[:error] = "Not a valid tamu.edu email address."
    end

    redirect_to "/studentform"
  end
end
