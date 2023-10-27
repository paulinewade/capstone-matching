class StudentformController < ApplicationController
    def index
    end

    def create
      # Extract form parameters
      email = params[:email]
      first_name = params[:first_name]
      last_name = params[:last_name]
      uin = params[:uin]
      if email.end_with?("tamu.edu")
        existing_student = StudentForm.find_by(email: email)

        if existing_student
          flash[:error] = "You are already registered using this email."
        else
          new_student = StudentForm.new(email: email, first_name: first_name, last_name: last_name, uin: uin)
          if new_student.save
            flash[:success] = "Registration Successful!."
          end
        end
      else
        flash[:error] = "Not a valid tamu.edu email address."
      end
      redirect_to "/StudentForm" and return
    end
end