class ProfregistrationController < ApplicationController
  def index
    @course_without_professors = Course.where(professor_id: nil)
  end

  def create
    # Extract form parameters
    puts(params)
    email = params[:email]
    first_name = params[:first_name]
    last_name = params[:last_name]
    courses = params[:courses]

    if email.end_with?("tamu.edu")
      existing_user = User.find_by(email: email)

      if existing_user
        flash[:error] = "You are already registered using this email. Please wait for the admin to approve your registration or login if you are already approved."
      else
        prof_user = User.new(email: email, first_name: first_name, last_name: last_name, role: "professor", user_id: 1)
        if prof_user.save
          professor_info = Professor.new(admin: false, verified: false, user_id: prof_user.id)
          if professor_info.save 
            flash[:success] = "Registration Successful! Please wait for admin approval."
          else
            flash[:error] = "Error with saving your information."
          end
        else
          flash[:error] = "User already registered."
        end
      end
    else
      flash[:error] = "Not a valid tamu.edu email address."
    end
    redirect_to profregistration_path and return
  end
end
